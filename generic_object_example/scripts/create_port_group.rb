$evm.log(:info, "*** In create_port_group ***")
go_class = $evm.vmdb(:generic_object_definition).find_by_name("PortGroup")

case $evm.root['vmdb_object_type']
when 'generic_object'
  name           = $evm.root['dialog_name']
  port           = $evm.root['dialog_port']
  description    = $evm.root['dialog_description']
  requester      = $evm.root['user'].name
  firewall_group = $evm.root['generic_object']
when 'service_template_provision_task'
  task           = $evm.root['service_template_provision_task']
  name           = task.dialog_options['dialog_name']
  port           = task.dialog_options['dialog_port']
  description    = task.dialog_options['dialog_description']
  requester      = task.miq_request.requester.name
  firewall_group = $evm.vmdb('generic_object', task.dialog_options['dialog_firewall_group'])
end

new_go = go_class.create_object(:name => name,
                                :port => port,
                         :description => description,
                           :requester => requester)
new_go.firewall_group = [firewall_group]
new_go.save!
firewall_group.port_groups += [new_go]
firewall_group.save!

# Update the service
unless $evm.root['service'].blank?
  new_go.add_to_service($evm.root['service'])
  $evm.root['service'].name = "Firewall Port Group: #{name}"
end