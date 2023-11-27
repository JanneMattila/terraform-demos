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
  }
}
