location = "north europe"

resource_group_name = "rg-tf-storage"

storage_name = "jannetfdemo0000010"

route_table_name = "rt-tf-storage"

additional_resource_groups = {
  rg-tf-create1 = {
    tags = {
      owner       = "owner 123"
      environment = "dev"
    }
  }

  rg-tf-create2 = {
    tags = {
      owner       = "owner 234"
      environment = "dev"
    }
  }
}
