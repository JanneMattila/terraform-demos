terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.80.0"
    }
    # https://registry.terraform.io/providers/Mastercard/restapi/latest/docs
    restapi = {
      source  = "Mastercard/restapi"
      version = ">=1.18.2"
    }
  }
  #   backend "azurerm" {
  #   }
}

provider "azurerm" {
  features {}
}
