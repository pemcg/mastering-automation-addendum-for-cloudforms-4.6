$evm.log(:info, "*** In create_network_group ***")
go_class = $evm.vmdb(:generic_object_definition).find_by_name("NetworkGroup")

case $evm.root['vmdb_object_type']
when 'generic_object'
  name           = $evm.root['dialog_name']
  network        = $evm.root['dialog_network']
  description    = $evm.root['dialog_description']
  requester      = $evm.root['user'].name
  firewall_group = $evm.root['generic_object']
when 'service_template_provision_task'
  task           = $evm.root['service_template_provision_task']
  name           = task.dialog_options['dialog_name']
  network        = task.dialog_options['dialog_network']
  description    = task.dialog_options['dialog_description']
  requester      = task.miq_request.requester.name
  firewall_group = $evm.vmdb('generic_object', task.dialog_options['dialog_firewall_group'])
end

new_go = go_class.create_object(:name => name,
                             :network => network,
                         :description => description,
                           :requester => requester)
new_go.firewall_group = [firewall_group]
new_go.save!
firewall_group.network_groups += [new_go]
firewall_group.save!

# Update the service
unless $evm.root['service'].blank?
  new_go.add_to_service($evm.root['service'])
  $evm.root['service'].name = "Firewall Network Group: #{name}"
end