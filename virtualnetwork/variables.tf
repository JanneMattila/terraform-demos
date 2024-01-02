variable "location" {}

variable "resource_group_name" {}
variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string

}

variable "hub_vnet" {
  description = "Hub virtual networks"
  type        = string
}

variable "hub_vnet_config" {
  type = map(object({
    subscription_id      = string
    resource_group_name  = string
    virtual_network_name = string
  }))
  default = {
    ne = {
      subscription_id      = "<subscription_id>"
      resource_group_name  = "rg-hub"
      virtual_network_name = "vnet-hub"
    }
    we = {
      subscription_id      = "<subscription_id>"
      resource_group_name  = "rg-hub"
      virtual_network_name = "vnet-hub"
    }
  }
}

variable "subnets" {
  type = map(object({
    name                   = string
    address_prefix         = string
    network_security_group = optional(string)
    route_table            = optional(string)
  }))
}

variable "network_security_groups" {
  type = map(object({
    name = string
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

variable "user_defined_routes" {
  type = map(object({
    name = string
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))
  }))
}
