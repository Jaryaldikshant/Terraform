terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate3rzx5e1o"
    container_name      = "terraform-state"
    key                 = "terraform.tfstate"
  }
} 