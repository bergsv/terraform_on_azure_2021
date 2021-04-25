terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
 
}

provider "azurerm" {
  features {  }
}

resource "azurerm_network_interface" "nic" {
    name = "nic-${var.servername}"
    resource_group_name = var.rgname
    location = var.location
    ip_configuration {
        name = "${var.servername}-internal"
        subnet_id = var.subnet_id
        private_ip_address_allocation = "Dynamic"   
    }
  
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.servername
  resource_group_name = var.rgname
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_password
  admin_password      = var.admin_password
  computer_name = "${var.servername}-cn"
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
}
