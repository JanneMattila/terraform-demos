

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]

  # subnet {
  #   name           = "snet-1"
  #   address_prefix = "10.0.0.0/24"
  # }

  # subnet {
  #   name           = "snet-2"
  #   address_prefix = "10.0.1.0/24"
  # }

  lifecycle {
    ignore_changes = [
      subnet
    ]
  }
}

resource "azurerm_subnet" "subnet" {
  name                                      = "snet-1"
  resource_group_name                       = azurerm_resource_group.resource_group.name
  virtual_network_name                      = azurerm_virtual_network.vnet.name
  address_prefixes                          = ["10.0.1.0/24"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

resource "azurerm_private_endpoint" "storage_pe" {
  name                = "pe-storage"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  subnet_id           = azurerm_virtual_network.vnet.subnet.*.id[0]

  private_service_connection {
    name                           = "pe-storage-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

module "name" {
  source = "./network"

  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  route_table_name    = var.route_table_name
}

resource "azurerm_resource_group" "rg" {
  for_each = var.additional_resource_groups
  location = var.location

  name = each.key
  tags = each.value.tags

  # lifecycle {
  #   ignore_changes = [
  #     tags
  #   ]
  # }
}
