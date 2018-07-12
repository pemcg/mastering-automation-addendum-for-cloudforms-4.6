## ManageIQ Ansible Modules

There are several ManageIQ-related modules and roles that can be used with Ansible 2.4.4.0 that is supplied with CloudForms 4.6.2. 

### Ansible 2.4 Compatible Modules

The following modules are supplied with Ansible 2.4 and later:

#### manageiq_provider
The [manageiq\_provider](http://docs.ansible.com/ansible/latest/modules/manageiq_provider_module.html) module supports adding, updating, and deleting providers in CloudForms/ManageIQ.

#### manageiq_user

The [manageiq\_user](http://docs.ansible.com/ansible/latest/modules/manageiq_user_module.html) module supports adding, updating and deleting users in CloudForms/ManageIQ.

### Ansible 2.4 Compatible Roles

The following Galaxy roles are compatible with Ansible 2.4 and later:

#### manageiq-vmdb

The [manageiq-vmdb](https://galaxy.ansible.com/syncrou/manageiq-vmdb) role allows for users of CloudForms/ManageIQ to modify and/or change VMDB objects via an Ansible Playbook

#### manageiq-automate

The [manageiq-automate](https://galaxy.ansible.com/syncrou/manageiq-automate) role allows for users of CloudForms/ManageIQ Automate to modify and add to the Automate Workspace via an Ansible Playbook

These roles are very useful when using Embedded Ansible playbook methods.

### Ansible 2.5 Compatible Modules

The following modules are supplied with Ansible 2.5, and so will be compatible with the version of Ansible supplied with a future version of CloudForms/ManageIQ:


The [manageiq\_alert\_profiles](http://docs.ansible.com/ansible/latest/modules/manageiq_alert_profiles_module.html) module supports adding, updating and deleting alert profiles in CloudForms/ManageIQ

The [manageiq\_alerts](http://docs.ansible.com/ansible/latest/modules/manageiq_alerts_module.html) module supports adding, updating and deleting alerts in CloudForms/ManageIQ

The [manageiq\_policies](http://docs.ansible.com/ansible/latest/modules/manageiq_policies_module.html) module supports adding and deleting policy_profiles in CloudForms/ManageIQ

The [manageiq\_tags](http://docs.ansible.com/ansible/latest/modules/manageiq_tags_module.html) module supports adding, updating and deleting tags in CloudForms/ManageIQ
