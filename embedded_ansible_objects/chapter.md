# Embedded Ansible Automation Objects

The implementation of embedded Ansible in CloudForms 4.6 (ManageIQ Gaprindashvili) is based on the [AWX project](https://github.com/ansible/awx) which provides a web-based user interface, REST API, and task engine built on top of Ansible. AWX is the upstream project for Ansible Tower, and so many of the terms and software objects and data structures are common to both.

> **Note**
> 
> It is likely that the implementation of embedded Ansible will be changed in a future release of CloudForms / ManageIQ, to reduce the memory and resource footprint that AWX consumes on an appliance with the **Embedded Ansible** role enabled. The objects described in this chapter may therefore also change or be removed to match the new implementation.

## Service Models

It is often useful to be able to access the embedded Ansible service model objects from Ruby automation scripts, although several of the objects are short-lived and deleted once a playbook job has run. Many of the objects map to their equivalents in the AWX object model.

The current AWX-based implementation uses several Automate service models, including the following:


### Manager

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager` object for each embedded Ansible provider in the region.

Typical `name`: "Embedded Ansible Automation Manager"

Useful Associations: `configured_systems`, `ems_events`, `ems_folders`, `provider` and `tenant`

href_slug: `providers/<id>`

### Configuration Script

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_ConfigurationScript` object for each provision or retirement script defined for an embedded Ansible service.

Typical `name`: "miq\_Install a Package\_provision"

Useful Associations: `inventory_root_group` and `manager`.

href_slug: none

### Configured System

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_ConfiguredSystem` object for each managed node that a job has run on (the _host_ for the job).

Has no `name` attribute but typical `hostname`: "192.168.1.66"

Useful Associations: `manager`

href_slug: none

### Machine Credential

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_MachineCredential` object per defined machine credential.

Typical `name`: "CFME Default Credential"

Associations: none

href_slug: `authentications/<id>`

### Inventory Root Group

There is one `ManageIQ_Providers_AutomationManager_InventoryRootGroup` object for each dynamic inventory created.

Typical `name`: "miq\_Install a Package_provision\_70"

Useful Associations: `configuration_scripts`, `hosts`, `manager` and `vms`

href_slug: none

### Playbook (aka Configuration Script Payload)

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_Playbook` object for each playbook imported from a configured SCM repository.

Typical `name`: "playbooks/configure\_vm\_network\_and\_ip.yml"

Useful Associations: `inventory_root_group` and `manager`.

href_slug: `configuration_script_payloads/<id>`

### Configuration Script Source

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_ConfigurationScriptSource` object for each configured SCM repository.

Typical `name`: "pemcg's Ansible Playbooks"

Useful Associations: `manager`

href_slug: `configuration_script_sources/<id>`

### Job

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_Job` object created for each job that’s run. The object derives from an `OrchestrationStack` object, and has a useful `job.stdout` virtual column that contains the job's text output.

Typical `name`: "miq\_Add a VM to Satellite 6\_provision"

Useful Associations: `ext_management_system`, `parameters` and `resources`.

href_slug: `orchestration_stacks/<id>`

### Job Parameter

There is one `OrchestrationStackParameter` object created for each parameter passed into a job. Each object has a `value` attribute that contains the parameter's value.

Typical `name`: "miq\_provision\_request\_id"

Useful Associations: `stack` (the job)

href_slug: none

### Job Resource

There is one `OrchestrationStackResource` object for each playbook that a job runs. Each object has a `resource_category` attribute of "job_play" and a `resource_status` attribute that indicates the play's status (i.e "successful")

Typical `name`: "Acquire and Set an IP Address"

Useful Associations: `stack` (the job)

href_slug: none

### Service Template Ansible Playbook

There is one `ServiceTemplateAnsiblePlaybook` object for each service catalog item of type 'Ansible Playbook'.

This object's options hash contains the default configuration settings for the service, for example:

```
$evm.root['service_template_ansible_playbook'].options[:config_info] = {:provision=>{:repository_id=>"14", :playbook_id=>"197", :credential_id=>"11", :hosts=>"localhost", :verbosity=>"0", :log_output=>"on_error", :extra_vars=>{:package=>{:default=>"from_service"}}, :execution_ttl=>"", :become_enabled=>true, :dialog_id=>"31", :fqname=>"/Service/Generic/StateMachines/GenericLifecycle/provision"}, :retirement=>{:remove_resources=>"yes_without_playbook", :verbosity=>"0", :log_output=>"on_error", :fqname=>"/Service/Generic/StateMachines/GenericLifecycle/Retire_Basic_Resource"}}   (type: Hash)
```
Useful Associations: `services` and `tenant`

href_slug: `service_templates/<id>`


### Service Ansible Playbook

There is one `ServiceAnsiblePlaybook` object for each ordered service of type 'Ansible Playbook'.

This object's options hash contains the default configuration settings for the service, the dialog options that were input when ordered, and the provision job options, for example:

```
$evm.root['service_ansible_playbook'].options[:config_info] = {:provision=>{:repository_id=>"14", :playbook_id=>"214", :credential_id=>"8", :hosts=>"localhost", :verbosity=>"0", :log_output=>"on_error", :extra_vars=>{}, :execution_ttl=>"", :become_enabled=>false, :dialog_id=>"40", :fqname=>"/Service/Generic/StateMachines/GenericLifecycle/provision"}, :retirement=>{:remove_resources=>"yes_without_playbook", :verbosity=>"0", :log_output=>"on_error", :fqname=>"/Service/Generic/StateMachines/GenericLifecycle/Retire_Basic_Resource"}}   (type: Hash)
$evm.root['service_ansible_playbook'].options[:dialog] = {"dialog_param_firewall_group"=>"46", "dialog_param_go_name"=>"rhv-net", "dialog_param_description"=>"RHV Network", "dialog_param_network"=>"172.16.1.0/24"}   (type: Hash)
$evm.root['service_ansible_playbook'].options[:provision_job_options] = {"hosts"=>"localhost", "extra_vars"=>{"firewall_group"=>"46", "go_name"=>"rhv-net", "description"=>"RHV Network", "network"=>"172.16.1.0/24"}}   (type: ActiveSupport::HashWithIndifferentAccess)
```

Useful Associations: `root_service`, `service_resources`, `service_template` and `tenant`

href_slug: `services/<id>`

## Summary

This chapter describes some of the service model objects that are involved in running an embedded Ansible playbook or method.





