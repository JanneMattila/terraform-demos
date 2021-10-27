terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    restapi = {
      source = "KirillMeleshko/restapi"
      # source  = "github.com/mastercard/restapi"
      version = "1.16.0"
    }
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

provider "restapi" {
  alias = "restapi_echo"
  uri   = "https://echo.jannemattila.com/"
  debug = true

  headers = {
    Authorization = var.bearer_token
  }

  create_method  = "POST"
  update_method  = "POST"
  destroy_method = "POST"
}

resource "restapi_object" "echo" {
  provider     = restapi.restapi_echo
  path         = "/api/echo?id={id}"
  id_attribute = var.ID
  object_id    = var.ID
  data         = "{ \"message\": \"This is from terraform: ${var.ID}\" }"
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
