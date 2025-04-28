
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
  default = "Canada Central"
  type    = string
}

variable "machine_size" {
  default = "Standard_DS1_v2"
  type    = string
}

variable "vm_count" {
  description = "Number of VM's"
  default = 2
  type = number
}

