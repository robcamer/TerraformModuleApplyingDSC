# Apply DSC to Virtual Machine Module

## Configuration

Review `variable.tf` for configurable settings.

## Example Usage:

```bash
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
```