variable "application" {
  type = string
  description = "Application Usage"
}

variable "location" {
 type = string 
 description = "Resource Location"
}

variable "admin_username" {
  type = string
  description = "Admin Username"
}

variable "admin_password" {
  type = string
  description = "Admin Password"
  sensitive = true
}

variable "vnet" {
    type = list
}

variable "subnet" {
    type = list
}

variable "vm_size" {
  type = string
}

variable "os" {
  type = object ({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}


variable "storage_account_type" {
    type = map
    default = {
    westeurope = "Standard_LRS"
    eastus = "Premium_LRS"
    }
}
