$evm.log(:info, "*** In create_address_group ***")
go_class = $evm.vmdb(:generic_object_definition).find_by_name("AddressGroup")

case $evm.root['vmdb_object_type']
when 'generic_object'
  name           = $evm.root['dialog_name']
  ip_address     = $evm.root['dialog_ip_address']
  description    = $evm.root['dialog_description']
  requester      = $evm.root['user'].name
  firewall_group = $evm.root['generic_object']
when 'service_template_provision_task'
  task           = $evm.root['service_template_provision_task']
  name           = task.dialog_options['dialog_name']
  ip_address     = task.dialog_options['dialog_ip_address']
  description    = task.dialog_options['dialog_description']
  requester      = task.miq_request.requester.name
  firewall_group = $evm.vmdb('generic_object', task.dialog_options['dialog_firewall_group'])
end

new_go = go_class.create_object(:name => name,
                          :ip_address => ip_address,
                         :description => description,
                           :requester => requester)
new_go.firewall_group = [firewall_group]
new_go.save!
firewall_group.address_groups += [new_go]
firewall_group.save!

# Update the service
unless $evm.root['service'].blank?
  new_go.add_to_service($evm.root['service'])
  $evm.root['service'].name = "Firewall Address Group: #{name}"
end