variable "prefix" {
  default = "vm-linux"
  type    = string
}

variable "password" {
  default = "Password1234!"
  type    = string
}

variable "username" {
  default = "azureuser"
  type    = string
}

variable "machine_name" {
  default = "HostName"
  type    = string
}

variable "location" {
  default = "westeurope"
  type    = string
}

variable "machine_size" {
  default = "Standard_DS1_v2"
  type    = string
}

variable "vm_configs" {
  description = "Map of VM configurations"
  type = map(object({
    vm_size : string
    vm_name : string
  }))

  default = {
    "vm1" = {
      vm_size = "Standard_B1s"
      vm_name = "vm1"
    },
    "vm2" = {
      vm_size = "Standard_B2s"
      vm_name = "vm2"
    },
    "vm3" = {
      vm_size = "Standard_B2s"
      vm_name = "vm3"
    }
  }
}

variable "env" {
  default = "dev"
  type    = string
}

