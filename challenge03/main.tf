terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
   backend "azurerm" {
    resource_group_name  = "Terraform-Course"
    storage_account_name = "cloudshell123155"
    container_name       = "terraformstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {  }
}

resource "azurerm_resource_group" "myresourcegroup"{ 
    name = "rg-${var.application}"
    location = "westeurope"
}

resource "azurerm_virtual_network" "myvirtualnetwork" {
    name = "myfancyvirtualnetwork"
    location = azurerm_resource_group.myresourcegroup.location
    resource_group_name = azurerm_resource_group.myresourcegroup.name
    address_space = var.vnet
}

resource "azurerm_subnet" "mysubnet" {
    name = "subnet-${var.application}"
    address_prefixes = var.subnet
    virtual_network_name = azurerm_virtual_network.myvirtualnetwork.name
    resource_group_name = azurerm_resource_group.myresourcegroup.name
}

resource "azurerm_network_interface" "mynetworkinterface" {
    name = "nic-${var.application}"
    resource_group_name = azurerm_resource_group.myresourcegroup.name
    location = azurerm_resource_group.myresourcegroup.location
    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.mysubnet.id
        private_ip_address_allocation = "Dynamic"   
    }
  
}

resource "azurerm_windows_virtual_machine" "myvm" {
  name                = "vm-${var.application}"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  size                = var.vm_size
  admin_username      = var.admin_password
  admin_password      = var.admin_password
  computer_name = "hanswurstpc"
  network_interface_ids = [
    azurerm_network_interface.mynetworkinterface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = lookup (var.storage_account_type, var.location)
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
}
