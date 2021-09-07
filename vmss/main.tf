terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

  # For service principals
  #   subscription_id = "<azure_subscription_id>"
  #   tenant_id       = "<azure_subscription_tenant_id>"
  #   client_id       = "<service_principal_appid>"
  #   client_secret   = "<service_principal_password>"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


resource "azurerm_virtual_network" "main-vnet" {
  name                = "main-vnet"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_subnet" "front-subnet" {
  name                 = "front-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "backend-subnet" {
  name                 = "backend-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "front-vmss" {
  name                            = "front-vmss"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  sku                             = "Standard_D4d_v4" # https://docs.microsoft.com/en-us/azure/virtual-machines/sizes
  instances                       = 3
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  zones                           = [1, 2, 3]
  zone_balance                    = true
  overprovision                   = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  network_interface {
    name                          = "nic"
    primary                       = true
    enable_accelerated_networking = true

    ip_configuration {
      name      = "public1"
      primary   = true
      subnet_id = azurerm_subnet.front-subnet.id

      public_ip_address {
        name = "pip"

        # Sep 2021: Terraform does not have support for 
        #           Setting up 'sku' for public IP
        # Ref. ARM: 
        # https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2021-04-01/virtualmachinescalesets?tabs=bicep#virtualmachinescalesetpublicipaddressconfiguration
        #
        # Therefore, you cannot use (yet) routing preferences (you'll get 'BasicSkuPublicIPAddressDoesNotSupportRoutingPreference' error).
        # You would need "Standard" Public IP:
        # sku = "Standard"
        # ip_tag {
        #   type = "RoutingPreference"
        #   tag  = "Internet"
        # }
      }
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS" # https://docs.microsoft.com/en-us/azure/virtual-machines/disks-types
    caching              = "ReadOnly"

    diff_disk_settings {
      option = "Local"
    }
  }
}
