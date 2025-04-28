output "vm_public_ip" {
  # value = azurerm_virtual_machine.main.public_ip
  value = azurerm_public_ip.public_ip.ip_address
}

output "vm_public_dns" {
  # value = azurerm_virtual_machine.main.vm_public_dns
  value = azurerm_public_ip.public_ip.fqdn
}


output "vm_private_id" {
  value = azurerm_network_interface.main.ip_configuration[0].private_ip_address

}