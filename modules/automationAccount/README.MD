

The Azure Run As Certificate value should come from KeyVault.  It should be in state configured as an output variable so that it is available in this format:
data.azurerm_key_vault_secret.AutomationRunAsAccountCert.value