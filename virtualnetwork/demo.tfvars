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
        destination_port_range     = "*"
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
        destination_port_range     = "*"
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
  }

  subnet2 = {
    name                   = "snet-2"
    address_prefix         = "10.0.1.0/24"
    network_security_group = "nsg1"
  }
}
