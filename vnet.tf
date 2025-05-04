module "avm-res-network-virtualnetwork" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm"

  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  name                = "Dikshantvnet"
  resource_group_name = azurerm_resource_group.my-rg.name
    tags = {
        Environmentnvironment = var.env
    }
  subnets = {
    "subnet1" = {
      name             = "subnet1"
      address_prefixes = ["10.0.0.0/24"]
    }
    "subnet2" = {
      name             = "subnet2"
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}