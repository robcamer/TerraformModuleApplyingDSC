output "automtionAccountName" {
  description = "The name of the Automation Account"
  value       = azurerm_automation_account.automation_account.name
}

output "automationAccountId" {
  description = "The id of the Automation Account"
  value       = azurerm_automation_account.automation_account.id
}

