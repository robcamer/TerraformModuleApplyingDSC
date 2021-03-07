resource "azurerm_automation_dsc_configuration" "dscWebServer" {
  name                    = var.dsc_name
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  location                = var.location
  content_embedded        = file(var.dsc_path)
  //  depends_on              = [azurerm_automation_account.automation_account]
}

// Requires that terraform be run on a machine with PowerShell Core installed
// Must call Connect-AzAccount prior to executing the below command
resource "null_resource" "azureSignInPWSH" {
  provisioner "local-exec" {
    command     = "$User = '${var.az_signin_appid}' ; $Pword =  ConvertTo-SecureString -String '${var.az_signin_appid_pwd}' -AsPlainText -Force ; $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord ; Connect-AzAccount -Environment ${var.cloud_environment} -Credential $Credential -Tenant '${var.tenant_id}' -ServicePrincipal"
    interpreter = ["pwsh", "-Command"]
  }
  triggers = {
    always_run = timestamp()
  }
  depends_on = [azurerm_automation_dsc_configuration.dscWebServer]
}

resource "null_resource" "compileDscdscConf1" {
  provisioner "local-exec" {
    command     = "Start-AzAutomationDscCompilationJob -ResourceGroupName  ${var.resource_group_name} -AutomationAccountName ${var.automation_account_name} -ConfigurationName '${var.dsc_name}'"
    interpreter = ["pwsh", "-Command"]
  }
  triggers = {
    always_run = timestamp()
  }
  depends_on = [null_resource.azureSignInPWSH]
} 