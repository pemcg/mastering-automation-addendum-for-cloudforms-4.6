# Embedded Ansible Objects

The implementation of embedded Ansible in CloudForms 4.6 (ManageIQ Gaprindashvili) is based on the [AWX project](https://github.com/ansible/awx) which provides a web-based user interface, REST API, and task engine built on top of Ansible. AWX is the upstream project for Ansible Tower, and so many of the terms and software objects and data structures are common to both.

> **Note**
> 
> It is likely that the implementation of embedded Ansible will be changed in a future release of CloudForms / ManageIQ, to reduce the memory and resource footprint that AWX consumes on an appliance with the **Embedded Ansible** role enabled. The objects described in this chapter may therefore also change or be removed to match the new implementation.

## Service Models

It is often useful to be able to access the embedded Ansible service model objects from Ruby automation scripts, although several of the objects are short-lived and deleted once a playbook job has run. Many of the objects map to their equivalents in the AWX object model.

The current AWX-based implementation uses several service models, including the following:


### Manager

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager` object for each embedded Ansible provider in the region.

Associations: `configuration_profiles`, `configured_systems`, `customization_specs`, `ems_clusters`, `ems_events`, `ems_folders`, `hosts`, `iso_datastore`, `miq_templates`, `provider`, `resource_pool`, `storages`, `tenant` and `vms`

### ConfigurationScript

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_ConfigurationScript` object for each provision or retirement script defined for an embedded Ansible service.

Associations: `inventory_root_group` and `manager`.

### ConfiguredSystem

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_ConfiguredSystem` object for each managed node that a playbook is run on.

Associations: `computer_system`, `configuration_location`, `configuration_profile`, `customization_script_medium`, `customization_script_ptable`, `manager` and `operating_system_flavor`

### InventoryRootGroup

There is one `ManageIQ_Providers_AutomationManager_InventoryRootGroup` object for each dynamic inventory created.

Associations: `configuration_scripts`, `hosts`, `manager` and `vms`

### Playbook

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_Playbook` object for each playbook imported from the configured repositories.

Associations: `inventory_root_group` and `manager`.

### Job

There is one `ManageIQ_Providers_EmbeddedAnsible_AutomationManager_Job` object created for each job that’s run. The object derives from an `OrchestrationStack` object, and has a useful `job.stdout` virtual column that contains the job's text output.

Associations: `ext_management_system`, `outputs`, `parameters` and `resources`.

### Job Parameter

There is one `OrchestrationStackParameter` object created for each parameter passed into a job.

Associations: `stack` (the job)

### Job Resource

There is one `OrchestrationStackResource` object for each playbook that a job runs.

Associations: `stack` (the job)

## Summary

This chapter describes some of the service model objects that are involved in running an embedded Ansible playbook or method.





