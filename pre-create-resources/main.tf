data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "tf-pre-created" {
  name     = var.pre_resource_group_name
  location = var.location

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                     = var.backend_storage_account_name # globally unique
  resource_group_name      = azurerm_resource_group.tf-pre-created.name
  location                 = azurerm_resource_group.tf-pre-created.location
  account_tier             = var.storage_account_account_tier
  account_replication_type = var.storage_account_account_replication_type # LRS, GRS, RAGRS, ZRS
  account_kind             = var.storage_account_account_kind

  identity {
    type = var.identity_type
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = var.backend_container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "tfstatebak-spike" {
  name                     = var.backup_storage_account_name
  resource_group_name      = azurerm_resource_group.tf-pre-created.name
  location                 = azurerm_resource_group.tf-pre-created.location
  account_tier             = var.storage_account_account_tier
  account_replication_type = var.storage_account_account_replication_type # LRS, GRS, RAGRS, ZRS
  account_kind             = var.storage_account_account_kind

  identity {
    type = var.identity_type
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_key_vault" "keyvaultautoapplydscrac" {
  name = var.key_vault_name
  location = var.location
  resource_group_name = var.pre_resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
}
