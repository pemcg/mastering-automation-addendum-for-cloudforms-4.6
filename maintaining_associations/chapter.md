# Maintaining Associations Between Generic Object Classes

One of the things that makes CloudForms generic objects very versatile is the ability to add associations to other object classes (including other generic objects) in the generic object definition. These associations can be one-to-one (has\_one in Rails-speak) or one-to-many (has\_many in Rails-speak).
 
The previous example uses generic object classes to represent firewall rules. The customer's firewall software uses the concept of a firewall group that contains one or more firewall actions, where each action equates to a firewall rule. The generic object definitions therefore included the following associations:
 
* A firewall\_group _has\_many_ firewall\_actions 
* A firewall\_action _has\_one_ firewall\_group
 
Implementing the has\_one rule from the action back to the group when creating the generic object from the API was fairly straightforward. The service catalog item to create a new firewall action has a dialog that prompts for the firewall group name to associate the action with.
 
The playbook first looks up the generic object of the correct group:

``` yaml
- name: Lookup the "Firewall Group" generic object supplied in the dialog
  uri:
    url: "{{ manageiq.api_url }}/api/generic_objects?expand=resources&filter[]=name='{{ firewall_group_name|urlencode }}'"
    method: GET
    validate_certs: no
    headers:
      X-Auth-Token: "{{ manageiq.api_token }}"
    body_format: json
  register: group_go
  
- set_fact:
    group_go_href: "{{ group_go.json.resources[0].href }}"
```

It then creates the new firewall action generic object, with a single association back to the firewall group:

``` yaml
- name: Create "Firewall Action" generic object
  uri:
    url: "{{ manageiq.api_url }}/api/generic_objects"
    method: POST
    validate_certs: no
    headers:
      X-Auth-Token: "{{ manageiq.api_token }}"
    body_format: json
    body:
      action: create
      name: "{{ ipaddress }}"
      generic_object_definition:
        href: "{{ action_go_definition_href }}"
      property_attributes:
        requester_department: "{{ group_description }}"
        requester: "{{ requester_name }}"
        ...
      associations:
        firewall_group:
        - href: "{{ group_go_href }}"
  register: action_go

- set_fact:
    action_go_href: "{{ action_go.json.results[0].href }}"
```

Adding the new firewall action to the list of has_many associations for the firewall group was less straightforward though. Just POSTing the new association will overwrite any existing associations. The existing associations must first be read, the new association appended to the list, and then the updated list POSTed back.

``` yaml
vars:
- association_hrefs: []
...

- name: Get the existing firewall_actions associations of the Firewall Group
  uri:
    url: "{{ group_go_href }}?associations=firewall_actions"
    method: GET
    validate_certs: no
    headers:
      X-Auth-Token: "{{ manageiq.api_token }}"
    body_format: json
  register: associations
  
# Extract the exiting association hrefs into their own list
- set_fact:
    association_hrefs: "{{ association_hrefs + [ { 'href': item.href } ] }}"
  with_items: "{{ associations.json.firewall_actions }}"
```

Add the new association href to the list:

``` yaml
- set_fact:
    association_hrefs: "{{ association_hrefs + [ { 'href': action_go_href } ] }}"
```

Now POST the updated list back to the generic object:

``` yaml
- name: Create the corresponding association in the Firewall Group back to the new action
  uri:
    url: "{{ group_go_href }}"
    method: POST
    validate_certs: no
    headers:
      X-Auth-Token: "{{ manageiq.api_token }}"
    body_format: json
    body:
      action: edit
      associations:
        firewall_actions:
          "{{ association_hrefs }}"
  register: output 
```

The generic object classes were then linked together as expected in the WebUI (the calls to the firewall software to create the actual actions/rules are not shown in this example - the generic objects just represent the firewall rules in the  CloudForms WebUI).
