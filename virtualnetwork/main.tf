resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "nsg" {
  for_each = var.network_security_groups

  name                = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value.name
      access                     = security_rule.value.access
      direction                  = security_rule.value.direction
      priority                   = security_rule.value.priority
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]


  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
      security_group = azurerm_network_security_group.nsg[subnet.value.network_security_group].id
    }
  }

  # lifecycle {
  #   ignore_changes = [
  #     subnet
  #   ]
  # }
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "${azurerm_virtual_network.vnet.name}-to-${var.hub_vnet_config[var.hub_vnet].virtual_network_name}"
  resource_group_name       = azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = "/subscriptions/${var.hub_vnet_config[var.hub_vnet].subscription_id}/resourceGroups/${var.hub_vnet_config[var.hub_vnet].resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.hub_vnet_config[var.hub_vnet].virtual_network_name}"
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "${var.hub_vnet_config[var.hub_vnet].virtual_network_name}-to-${azurerm_virtual_network.vnet.name}"
  resource_group_name       = var.hub_vnet_config[var.hub_vnet].resource_group_name
  virtual_network_name      = var.hub_vnet_config[var.hub_vnet].virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  provider                  = azurerm.hub
}

