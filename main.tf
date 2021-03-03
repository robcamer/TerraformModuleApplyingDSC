# PRE-CREATED RESOURCE DATA SOURCES
data "azurerm_key_vault" "KeyVaultData" {
  name                = var.key_vault_name
  resource_group_name = var.pre_resource_group_name
}

data "azurerm_key_vault_certificate" "AutomationRunAsAccountCert" {
  name         = "AutomationRunAsAccountCert"
  key_vault_id = data.azurerm_key_vault.KeyVaultData.id
}

data "azurerm_key_vault_secret" "AutomationRunAsAccountAppId" {
  name         = "AutomationRunAsAccountAppId"
  key_vault_id = data.azurerm_key_vault.KeyVaultData.id
}

data "azurerm_key_vault_secret" "AutomationRunAsAccountAppSecret" {
  name         = "AutomationRunAsAccountAppSecret"
  key_vault_id = data.azurerm_key_vault.KeyVaultData.id
}

data "azurerm_key_vault_secret" "AutomationRunAsCertThumbprint" {
  name         = "AutomationRunAsCertThumbprint"
  key_vault_id = data.azurerm_key_vault.KeyVaultData.id
}

# DATA SORUCE TO OBTAIN CLIENT ENVIRONMENT CONFIGURATION
data "azurerm_client_config" "dscSpike" {}


# CREATE AUTOMATION ACCOUNT
resource "azurerm_resource_group" "automation_dsc_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment_tag
  }
}

# module "automation_account" {
#   source                             = "./modules/automation"
#   location                           = azurerm_resource_group.automation_dsc_rg.location
#   resource_group_name                = azurerm_resource_group.automation_dsc_rg.name
#   automation_account_name            = var.automation_account_name
#   automation_run_as_certificate_name = var.automation_run_as_certificate_name
# }