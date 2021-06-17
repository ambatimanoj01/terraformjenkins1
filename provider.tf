provider "azurerm" {

  version = "=2.4.0"

  subscription_id = "da703167-56cd-4646-9246-a22573e7032c"
  client_id       = "79095b79-ae02-48bf-b709-e76ebd68c7b3"
  client_secret   = "kK54cy8wiC7L4U_t1Wla74W761M.~4k~Y1"
  tenant_id       = "b13f86ff-cb25-4401-8e04-6b971099fd32"

  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "rgmanojdiag"
    container_name       = "container1"
    key                  = "staging.terraform.tfstate"
access_key="n/4b1SxcftqlnHGCSWHwjdWSOr0LOvo/DTnFM2m64nF5DXElAQV9LDDm9iCgNnvHpHTbE5UlBD50coMAE4/c8w=="
  }
}