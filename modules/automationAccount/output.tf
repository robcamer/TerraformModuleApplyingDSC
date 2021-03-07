output "automtion_account_name" {
  description = "The name of the Automation Account"
  value       = azurerm_automation_account.automation_account.name
}

output "automation_account_id" {
  description = "The id of the Automation Account"
  value       = azurerm_automation_account.automation_account.id
}

output "automation_account_access_key" {
  description = "The Automation Account Access Key required to enable the DSC extension on the virtual machine."
  value       = azurerm_automation_account.automation_account.dsc_primary_access_key
  sensitive   = true
}

output "automation_account_dsc_server_endpoint" {
  description = "The Automation Account DSC server endpoint required to enable the DSC extension on the virtual machine."
  value       = azurerm_automation_account.automation_account.dsc_server_endpoint
}