# Maintaining Associations Between Generic Objects from Ansible

One of the things that makes CloudForms generic objects very versatile is the ability to add associations to other object classes (including other generic objects) in the generic object definition. These associations can be be implemented as one-to-one (_has\_one_ in Rails-speak) or one-to-many (_has\_many_ in Rails-speak).

> **Note**
> 
> Associations between generic objects are always _has\_many_, even though we may wish to logically implement them as _has\_one_
 
The previous example used generic object classes to represent firewall groups and their components. The firewall software uses the concept of a firewall group that contains one or more port groups, network groups and address groups, and so the generic object definitions included the following associations:
 
* A firewall\_group has\_many port\_groups, network\_groups and address\_groups
* A port\_group, network\_groups and address\_groups each has\_one firewall\_group

Implementing generic object associations from Ruby is straightforward. The has\_one association is a simple assignment, as follows:

``` ruby
new_go.firewall_group = [firewall_group]
```

Implementing the has\_many association from Ruby is a matter of adding the new association to an existing association list, as follows:

``` ruby
firewall_group.network_groups += [new_go]
```
## Associations from Ansible
 
Generic object associations can also be created from Ansible. The following playbook snippets show an alternative way of linking a newly created _NetworkGroup_ object to its parent _FirewallGroup_ object.

Implementing a has\_one rule from an Ansible playbook is fairly straightforward. The playbook first creates the new network group generic object, with a single association back to the firewall group:

``` yaml
  - name: "Create {{ go_name }} generic object"
    uri:
      url: "{{ manageiq.api_url }}/api/generic_objects"
      method: POST
      validate_certs: no
      headers:
        X-Auth-Token: "{{ manageiq.api_token }}"
      body_format: json
      body:
        action: create
        name: "{{ go_name }}"
        generic_object_definition:
          href: "{{ go_definition_href }}"
        property_attributes:
          network: "{{ network }}"
          description: "{{ description }}"
          requester: "{{ requester.json.name }}"
        associations:
          firewall_group:
          - href: "{{ fwgroup_go_href }}"
    register: new_go
  
  - set_fact:
      new_go_href: "{{ new_go.json.results[0].href }}"
```

Adding the new network group to the list of has_many associations for the firewall group is less straightforward though. Just POSTing the new association will overwrite any existing associations. The existing associations must first be read, the new association appended to the list, and then the updated list POSTed back.

``` yaml
  - name: Get the existing network_groups associations of the Firewall Group
    uri:
      url: "{{ fwgroup_go_href }}?associations=network_groups"
      method: GET
      validate_certs: no
      headers:
        X-Auth-Token: "{{ manageiq.api_token }}"
      body_format: json
    register: associations
```

A typical json extract of the _network\_groups_ association list from the registered `associations` variable might be as follows:

```
"associations": {
    ...
    "json": {
    ...
        "network_groups": [
        {
            "created_at": "2018-07-30T17:00:02Z",
            "generic_object_definition_id": "4",
            "href": "https://10.2.3.4/api/generic_objects/50",
            "id": "50",
            "name": "dmz-nets",
            "updated_at": "2018-07-30T17:00:02Z"
        },
        {
            "created_at": "2018-07-27T13:08:55Z",
            "generic_object_definition_id": "4",
            "href": "https://10.2.3.4/api/generic_objects/47",
            "id": "47",
            "name": "good-nets",
            "updated_at": "2018-07-27T13:08:56Z"
        },
        {
            "created_at": "2018-07-30T16:33:30Z",
            "generic_object_definition_id": "4",
            "href": "https://10.2.3.4/api/generic_objects/49",
            "id": "49",
            "name": "bad-nets",
            "updated_at": "2018-07-30T16:33:30Z"
        }
        ],
        ...
```

We need to extract the existing association hrefs into their own list...

``` yaml
vars:
- association_hrefs: []
...
  - set_fact:
      association_hrefs: "{{ association_hrefs + [ { 'href': item } ] }}"
    with_items: "{{ associations|json_query('json.network_groups[*].href') }}"
```

Add the new association href to the list:

``` yaml
  - set_fact:
      association_hrefs: "{{ association_hrefs + [ { 'href': new_go_href } ] }}"
```

Now POST the updated list back to the generic object:

``` yaml
  - name: Create the corresponding association in the Firewall Group back to the new action
    uri:
      url: "{{ fwgroup_go_href }}"
      method: POST
      validate_certs: no
      headers:
        X-Auth-Token: "{{ manageiq.api_token }}"
      body_format: json
      body:
        action: edit
        associations:
          network_groups:
            "{{ association_hrefs }}"
    register: output 
```

The generic object classes now appear linked together as expected in the WebUI.

## Summary

This chapter has shown how generic objects can be created and linked together in associations, from an Ansible playbook. The full scripts are available [here](https://github.com/pemcg/mastering-automation-addendum-for-cloudforms-4.6/tree/master/generic_object_example/scripts)

## References

[Ansible Filters](https://docs.ansible.com/ansible/2.3/playbooks_filters.html)
