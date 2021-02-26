

resource "azurerm_automation_account" "automation_account" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.environment_tag

  sku_name = "Basic" #only Basic is supported at this time.
}

resource "azurerm_automation_runbook" "install_automation_update_runbook" {
  name                    = "Update-AutomationAzureModulesForAccount"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation_account.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "To update the Azure modules in your Automation account, you must use the Update-AutomationAzureModulesForAccount runbook, which is available as open source"
  runbook_type            = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/microsoft/AzureAutomation-Account-Modules-Update/master/Update-AutomationAzureModulesForAccount.ps1"
  }
  depends_on = [azurerm_automation_account.automation_account]
}

resource "azurerm_automation_schedule" "automation_run_once" {
  name                    = "update_module_automation"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation_account.name
  frequency               = "OneTime"
  # timezone                = "US Eastern Standard Time"
  timezone    = "America/New_York"
  description = "One time schedule to update modules"
}

resource "azurerm_automation_job_schedule" "automation_job" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation_account.name
  runbook_name            = azurerm_automation_runbook.install_automation_update_runbook.name
  schedule_name           = azurerm_automation_schedule.automation_run_once.name
  parameters = {
    resourcegroupname     = var.resource_group_name
    automationaccountname = azurerm_automation_account.automation_account.name
  }
}

# Azure AUtomation RunAs Account
resource "azurerm_automation_certificate" "automationAccountCertificate" {
  name                    = var.automation_run_as_certificate_name
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation_account.name

  description = var.automation_run_as_certificate_name
  # Certificate must be in .pfx format without a password encoded in base64
  base64 = data.azurerm_key_vault_secret.AutomationRunAsAccountCert.value
}

# TO DO - CLEAN UP
resource "azurerm_automation_connection" "automationAccountConnection" {
  name                    = var.AUTOMATION_RUN_AS_CONNECTION_NAME
  resource_group_name     = azurerm_resource_group.automation_dsc_rg.name
  automation_account_name = azurerm_automation_account.automation_account.name
  type                    = var.AUTOMATION_RUN_AS_CONNECTION_TYPE

  values = {
    "ApplicationId" : data.azurerm_key_vault_secret.AutomationRunAsAccountAppId.value,
    "TenantId" : data.azurerm_client_config.dscSpike.tenant_id,
    "SubscriptionId" : data.azurerm_client_config.dscSpike.subscription_id,
    "CertificateThumbprint" : data.azurerm_key_vault_secret.AutomationRunAsCertThumbprint.value
  }
}