resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "snet-1"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name           = "snet-2"
    address_prefix = "10.0.1.0/24"
  }

  lifecycle {
    ignore_changes = [
      subnet
    ]
  }
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "${var.hub_vnet_config[var.hub_vnet].virtual_network_name}-to-${azurerm_virtual_network.vnet.name}"
  resource_group_name       = azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = "/subscriptions/${var.hub_vnet_config[var.hub_vnet].subscription_id}/resourceGroups/${var.hub_vnet_config[var.hub_vnet].resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.hub_vnet_config[var.hub_vnet].virtual_network_name}"
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "${azurerm_virtual_network.vnet.name}-to-${var.hub_vnet_config[var.hub_vnet].virtual_network_name}"
  resource_group_name       = var.hub_vnet_config[var.hub_vnet].resource_group_name
  virtual_network_name      = var.hub_vnet_config[var.hub_vnet].virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  provider                  = azurerm.hub
}

