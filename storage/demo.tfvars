location = "north europe"

resource_group_name = "rg-tf-storage"

storage_name = "jannetfdemo0000010"

route_table_name = "rt-tf-storage"

additional_resource_groups = {
  first = {
    name = "rg-tf-create1"
    tags = {
      environment = "dev"
    }
  }
}
