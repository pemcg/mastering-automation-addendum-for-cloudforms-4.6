# Embedded Ansible Services

New service catalog item type, *Ansible Playbook*

## Generic State Machine

## Variables Available to the Ansible Playbook

When an Ansible playbook is run as a service, a number of
manageiq-specific variables are made available to the playbook to use.

``` yaml
"manageiq": {
    "X_MIQ_Group": "EvmGroup-super_administrator",
    "action": "Provision",
    "api_token": "ef956ff763ccf6c1ca77199eff6e25f2",
    "api_url": "https://192.168.2.242",
    "group": "groups/2",
    "service": "services/27",
    "user": "users/1"
},
"manageiq_connection": {
    "X_MIQ_Group": "EvmGroup-super_administrator",
    "token": "ef956ff763ccf6c1ca77199eff6e25f2",
    "url": "https://192.168.2.242"
}
```

## Inventory

The inventory group ‘all’ is created on-the-fly when the playbook is
launched:

``` yaml
...
"groups": {
    "all": [
        "192.168.2.182"
     ],
     "ungrouped": [
         "192.168.2.182"
     ]
}
…
"inventory_hostname": "192.168.2.182",
```

So in playbook use:

    hosts: all

## Service Retirement

retirement of service objects: VMs and generic objects

## Calling an Ansible Playbook Service Programmatically

    create_service_provision_request

    order_ansible_playbook

## Debugging

Optionally logging playbook output to evm.log:

2\) Optionally increasing the logging verbosity level of the playbook:

3\) Dumping playbook variables:

<https://github.com/pemcg/ansible-role-listvars> roles: -
ansible-role-listvars

## Deleting the Service Once the Playbook has Run
