# Define the number of VMs you want to create globally


# RESOURCE GROUP
resource "azurerm_resource_group" "my-rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# VIRTUAL NETWORK
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name
}

# SUBNET
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.my-rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# NETWORK SECURITY GROUP
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name

  # rules to allow SSH access (port 22)
  security_rule {
    name                       = "allow_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # rules to allow HTTP access (port 80)
  security_rule {
    name                       = "allow_http"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ASSOCIATE NSG TO SUBNET
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on               = [azurerm_network_security_group.nsg, azurerm_subnet.internal]
}

# PUBLIC IP
resource "azurerm_public_ip" "public_ip" {
  for_each            = var.vm_configs
  name                = "${var.prefix}-public-ip-${each.key}"
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-vm-pip-${each.key}"
}

# NETWORK INTERFACE
resource "azurerm_network_interface" "main" {
  for_each            = var.vm_configs
  name                = "${var.prefix}-nic-${each.key}"
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
  }
}

# VIRTUAL MACHINE
resource "azurerm_virtual_machine" "main" {
  for_each              = var.vm_configs
  name                  = each.value.vm_name
  location              = azurerm_resource_group.my-rg.location
  resource_group_name   = azurerm_resource_group.my-rg.name
  network_interface_ids = [azurerm_network_interface.main[each.key].id]
  vm_size               = "Standard_B1ls"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk-${each.key}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = each.value.vm_name
    admin_username = var.username
    admin_password = var.password
    custom_data    = base64encode(file("install_nginx.sh"))
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = file("ssh_Key.pub")
    }
  }

  tags = {
    environment = "staging"
  }
}


