# VARIABLES
variable "prefix" {
  default = "tfvm-linux"
}

# RESOURCE GROUP
resource "azurerm_resource_group" "my-rg" {
  name     = "${var.prefix}-rg"
  location = "Canada Central"
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
}

# ASSOCIATE NSG TO SUBNET
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# PUBLIC IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-public-ip"
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-vm-pip"
}

# NETWORK INTERFACE
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# VIRTUAL MACHINE
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.my-rg.location
  resource_group_name   = azurerm_resource_group.my-rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}
