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
    key                  = "module.terraform.tfstate"
  }
}

provider "azurerm" {
  features {  }
}

resource "azurerm_resource_group" "myresourcegroup"{ 
    name = "myfancyresourcegroup"
    location = "westeurope"
}

resource "azurerm_virtual_network" "myvnet" {
    name = "myfancyvirtualnetwork"
    location = azurerm_resource_group.myresourcegroup.location
    resource_group_name = azurerm_resource_group.myresourcegroup.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "mysubnet" {
    name = "subnet"
    address_prefixes = ["10.0.1.0/24"]
    virtual_network_name = azurerm_virtual_network.myvnet.name
    resource_group_name = azurerm_resource_group.myresourcegroup.name
}

module "server" {
  source = "./modules/terraform-azure-server"

  subnet_id = azurerm_subnet.mysubnet.id
  rgname = azurerm_resource_group.myresourcegroup.name
  location = azurerm_resource_group.myresourcegroup.location

  servername = "mytestvm1"
  vm_size = "Standard_B1s"
  admin_password = "sehrsicher123!"
  admin_username = "azureadmin"
  os = {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }

}