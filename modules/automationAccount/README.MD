# Automation Account Module

## Configuration

Review `variable.tf` for configurable settings.

## Example Usage:

```bash
module "automation_account" {
  source                                   = "./modules/automationAccount"
  location                                 = azurerm_resource_group.automation_dsc_rg.location
  resource_group_name                      = azurerm_resource_group.automation_dsc_rg.name
  automation_account_name                  = var.automation_account_name
  automation_run_as_certificate_name       = var.automation_run_as_certificate_name
  automation_run_as_certificate_thumbprint = data.azurerm_key_vault_certificate.AutomationRunAsAccountCert.thumbprint
  automation_run_as_account_cert           = data.azurerm_key_vault_certificate.AutomationRunAsAccountCert.certificate_data_base64
  automation_run_as_appid                  = data.azurerm_key_vault_secret.AutomationRunAsAccountAppId.value
  tenantId                                 = data.azurerm_client_config.applyDSCConfig.tenant_id
  subscriptionId                           = data.azurerm_client_config.applyDSCConfig.subscription_id
}
```
