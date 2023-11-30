provider "restapi" {
  alias                = "restapi_myip"
  uri                  = "https://api.ipify.org"
  debug                = true
  write_returns_object = true

  headers = {
    Authorization = var.bearer_token
  }

  create_method  = "GET"
  update_method  = "GET"
  destroy_method = "GET"
}

resource "restapi_object" "myip" {
  provider     = restapi.restapi_myip
  query_string = "format=json"
  path         = "/"
  id_attribute = "ip"
  object_id    = "ip"
  data         = ""
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
    ip_rules = [
      restapi_object.myip.api_data["ip"]
    ]
  }
}
