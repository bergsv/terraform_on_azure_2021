provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "myresourcegroup"{ 
    name = "myfancyresourcegroup"
    location = "westeurope"
}

resource "azurerm_virtual_network" "myvirtualnetwork" {
    name = "myfancyvirtualnetwork"
    location = azurerm_resource_group.myresourcegroup.location
    resource_group_name = azurerm_resource_group.myresourcegroup.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "mysubnet" {
    name = "mycutesubnet"
    address_prefixes = [ "10.0.1.0/24" ]
    virtual_network_name = azurerm_virtual_network.myvirtualnetwork.name
    resource_group_name = azurerm_resource_group.myresourcegroup.name
}

resource "azurerm_network_interface" "mynetworkinterface" {
    name = "cutenic"
    resource_group_name = azurerm_resource_group.myresourcegroup.name
    location = azurerm_resource_group.myresourcegroup.location
    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.mysubnet.id
        private_ip_address_allocation = "Dynamic"   
    }
  
}

resource "azurerm_windows_virtual_machine" "myvm" {
  name                = "myvirtualmachine"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "Pleasechangeme123!"
  computer_name = "hanswurstpc"
  network_interface_ids = [
    azurerm_network_interface.mynetworkinterface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
