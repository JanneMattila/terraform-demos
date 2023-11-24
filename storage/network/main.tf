
resource "azurerm_route_table" "standard_route_table" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
}
