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

data "azurerm_key_vault_secret" "vmTestPassword" {
  name         = "ApplyDscTestVmPassword"
  key_vault_id = data.azurerm_key_vault.KeyVaultData.id
}

# DATA SORUCE TO OBTAIN CLIENT ENVIRONMENT CONFIGURATION
data "azurerm_client_config" "applyDSCConfig" {}


# CREATE AUTOMATION ACCOUNT
resource "azurerm_resource_group" "automation_dsc_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment_tag
  }
}

module "automation_account" {
  source                                   = "./modules/automationAccount"
  location                                 = azurerm_resource_group.automation_dsc_rg.location
  resource_group_name                      = azurerm_resource_group.automation_dsc_rg.name
  automation_account_name                  = var.automation_account_name
  automation_run_as_certificate_name       = var.automation_run_as_certificate_name
  automation_run_as_certificate_thumbprint = data.azurerm_key_vault_secret.AutomationRunAsCertThumbprint.value
  automation_run_as_account_cert           = data.azurerm_key_vault_certificate.AutomationRunAsAccountCert.certificate_data_base64
  automation_run_as_appid                  = data.azurerm_key_vault_secret.AutomationRunAsAccountAppId.value
  tenantId                                 = data.azurerm_client_config.applyDSCConfig.tenant_id
  subscriptionId                           = data.azurerm_client_config.applyDSCConfig.subscription_id
}

module "dsc" {
  source                  = "./modules/dsc"
  location                = azurerm_resource_group.automation_dsc_rg.location
  resource_group_name     = azurerm_resource_group.automation_dsc_rg.name
  automation_account_name = module.automation_account.automtion_account_name
  az_signin_appid         = data.azurerm_key_vault_secret.AutomationRunAsAccountAppId.value
  az_signin_appid_pwd     = data.azurerm_key_vault_secret.AutomationRunAsAccountAppSecret.value
  dsc_path                = var.dsc_path
  dsc_name                = var.dsc_name
  cloud_environment       = var.CLOUD_ENVIRONMENT
  tenant_id               = var.ARM_TENANT_ID
}

module "vmApplyDsc" {
  source                                 = "./modules/vmApplyDsc"
  location                               = azurerm_resource_group.automation_dsc_rg.location
  vm_name                                = var.vm_name
  vm_extension_name                      = var.vm_extension_name
  dsc_config_name                        = var.dsc_config_name
  vm_vnet_name                           = var.vm_vnet_name
  vm_subnet_name                         = var.vm_subnet_name
  vm_admin_password                      = data.azurerm_key_vault_secret.vmTestPassword.value
  automation_account_access_key          = module.automation_account.automation_account_access_key
  automation_account_dsc_server_endpoint = module.automation_account.automation_account_dsc_server_endpoint
}

