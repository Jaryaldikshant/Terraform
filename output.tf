// Output for count

# output "vm_public_ip" {
#   # value = azurerm_virtual_machine.main.public_ip
#   value = azurerm_public_ip.public_ip[*].ip_address
# }

# output "vm_public_dns" {
#   # value = azurerm_virtual_machine.main.vm_public_dns
#   value = azurerm_public_ip.public_ip[*].fqdn
# }


# output "vm_private_id_1" {
#   value = azurerm_network_interface.main[1].ip_configuration[0].private_ip_address
# }

# output "vm_private_id_0" {
#   value = azurerm_network_interface.main[0].ip_configuration[0].private_ip_address
# }





// Output for For each
output "vm_public_ip" {
  value = [
    for ip in azurerm_public_ip.public_ip : ip.ip_address
  ]
}

output "vm_public_dns" {
  value = [
    for ip in azurerm_public_ip.public_ip : ip.fqdn
  ]
}

output "vm_private_ip" {
  value = [
    for nic in azurerm_network_interface.main : nic.ip_configuration[0].private_ip_address
  ]
}

