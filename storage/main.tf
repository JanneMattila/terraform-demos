terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}

  # For service principals
  #   subscription_id = "<azure_subscription_id>"
  #   tenant_id       = "<azure_subscription_tenant_id>"
  #   client_id       = "<service_principal_appid>"
  #   client_secret   = "<service_principal_password>"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"
    ip_rules       = []
  }
}
