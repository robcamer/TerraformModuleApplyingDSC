provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  #version = ">=2.48.0"
  features {}
  #environment = "usgovernment"
  #subscription_id = "8b0b688a-163d-4ef4-a93e-43dd1593371a"
  #subscription_id = "3d02b1ba-2d66-4c30-9d49-d75f51ea0e10"
}

terraform {
  required_providers {
  azurerm = {
      # The "hashicorp" namespace is the new home for the HashiCorp-maintained
      # provider plugins.
      #
      # source is not required for the hashicorp/* namespace as a measure of
      # backward compatibility for commonly-used providers, but recommended for
      # explicitness.
      source  = "hashicorp/azurerm"
      version = "~> 2.48"
    }
  }

   backend "azurerm" {
    resource_group_name   = "tf-module-bootup-state-rg"
    storage_account_name  = "tfbootstoragemodulerac"
    container_name        = "tfrsmodule"
    key                   = "terraform.tfstate"
  }
}