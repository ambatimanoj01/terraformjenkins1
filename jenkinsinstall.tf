terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.62.0"
    }
  }
}

 provider "azurerm" {
 features {}
}

 resource "azurerm_resource_group" "test" {
  name     = var.rgname
 location = var.location
}

data "azurerm_resources" "test" {
  resource_group_name = var.rgname
}

resource "azurerm_virtual_network" "test" {
  name                = var.vnet
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "test" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "test" {
  name                = var.network_interface
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ip_configuration {
    name                          = "ptestconfiguration1"
    subnet_id                     = azurerm_subnet.test.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_storage_account" "test" {
  name                     = var.storage_account
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "test" {
  name                  = var.storage_container
  storage_account_name  = azurerm_storage_account.test.name
  container_access_type = "private"
}

resource "azurerm_virtual_machine" "test" {
  name                  = var.virtual_machine
  location              = azurerm_resource_group.test.location
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = [azurerm_network_interface.test.id]
  vm_size               = "Standard_F2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "myosdisk1"
    vhd_uri       = "${azurerm_storage_account.test.primary_blob_endpoint}${azurerm_storage_container.test.name}/myosdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
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

resource "azurerm_virtual_machine_extension" "test" {
  name                 = "jenkinsExtensionnew"
  virtual_machine_id   = azurerm_virtual_machine.test.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

 # settings = <<SETTINGS
   # {
       # "commandToExecute": "sudo install git -Command \"sudo install jdk\" -Command \"sudo apt install openjdk-8-jdk\" - Command \"sudo apt update\" - Command \"wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -\" -Command \"sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
#\" -Command \"sudo apt update\" -Command \"sudo apt install jenkins\" -Command \"systemctl status jenkins\" -Command \"sudo ufw allow 8080\" -Command \"sudo ufw status\""
   # }
#SETTINGS


  tags = {
    environment = "Production"
  }
}



