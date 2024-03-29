provider "azurerm" {
  features {}

  skip_provider_registration = true
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_vnet_config[var.hub_vnet].subscription_id
  features {}

  skip_provider_registration = true
}
