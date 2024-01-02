location = "north europe"

resource_group_name  = "rg-tf-vnet"
virtual_network_name = "vnet-tf"

hub_vnet = "ne"

network_security_groups = {
  nsg1 = {
    name = "nsg-1"
    security_rules = [
      {
        name                       = "denySSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  nsg2 = {
    name = "nsg-2"
    security_rules = [
      {
        name                       = "rule1"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1234"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "rule2"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "5000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}

subnets = {
  subnet1 = {
    name                   = "snet-1"
    address_prefix         = "10.0.0.0/24"
    network_security_group = "nsg1"
    route_table            = "app1"
  }

  subnet2 = {
    name                   = "snet-2"
    address_prefix         = "10.0.1.0/24"
    network_security_group = "nsg1"
  }

  subnet3 = {
    name           = "snet-3"
    address_prefix = "10.0.2.0/24"
  }
}

user_defined_routes = {
  app1 = {
    name = "rt-app1"
    routes = [{
      name                   = "route1"
      address_prefix         = "10.0.0.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.20.30.40"
    }]
  }

  app2 = {
    name = "rt-app2"
    routes = [{
      name                   = "route1"
      address_prefix         = "10.0.1.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "11.22.33.44"
    }]
  }
}
