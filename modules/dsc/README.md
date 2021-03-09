# Desired State Configuration (DSC) Module

## Configuration

Review `variable.tf` for configurable settings.

## Example Usage:

```bash
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
```