variable "location" {}

variable "resource_group_name" {}

variable "storage_name" {}

variable "additional_resource_groups" {
  type = map(object({
    name = string
    tags = optional(map(string), {})
  }))
}
