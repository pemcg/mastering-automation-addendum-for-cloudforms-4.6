# Ansible Tower Provider Update

CloudForms 4.2 (ManageIQ *Euwe*) introduced the Ansible Tower provider that allows us to run Tower Job Templates on an external Ansible Tower server. The provider was designated as a **Configuration** provider, along with the Foreman and Satellite provider types.

Since CloudForms 4.5 (ManageIQ *Fine*) the Ansible Tower provider has been re-designated as an **Automation** provider. The provider explorer and jobs are accessed from **Automation -> Ansible Tower** in the WebUI.

## Automate Datastore Changes

In keeping with the designation change, the _ConfigurationManagement_ namespace has been renamed to _ConfigurationManagement (Deprecated)_ in the Automate Datastore, and a new _AutomationManagement_ namespace has been created containing the _AnsibleTower_ namespace. Some new instances and methods have need added to the new namespace and class structure.

## Object Name Changes



Handling Inventories
