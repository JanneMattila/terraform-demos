terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.80.0"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_vnet_config[var.hub_vnet].subscription_id
  features {}
}