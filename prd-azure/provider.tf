terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.29.1"
    }
  }
}

provider "azurerm" {
  features {}

  client_id = "cb7d3b48-7a7a-473e-a72b-416ad21f67fb"
  client_secret = "Ffs8Q~Uj.dvxROn~Tpn6HfnYsV~ABqkj9jtKudel"
  subscription_id = "676452ad-1286-44f1-a7ea-a7dcef5f8c8c"
  tenant_id = "05235d3a-8db4-477b-8b3d-3b4331907dcd"
}

resource "azurerm_resource_group" "LSF_RC_RG" {
  name = "LSF_RC_RG"
  location = "Korea Central"
}