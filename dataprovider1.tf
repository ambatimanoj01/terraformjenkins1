terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.63.0"
    }
  }
}

data "azurerm_resources" "example" {
  resource_group_name = "jenkinsRG7"
}


resource "azurerm_virtual_machine_scale_set_extension" "example" {
  name                         = "examplevss"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.example.id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"
  settings = jsonencode({
    "commandToExecute" = "echo $HOSTNAME"
  })
}