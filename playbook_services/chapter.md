# Ansible Playbook Services

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
