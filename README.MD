# Terraform, Azure Automation, and aply a DSC to a Virtual Machine

## Overview
This example consists of an example that leverages three terraform modules located in the modules folder:

1. automationAccount
2. dsc
3. vmApplyDsc

Running this exmaple will deploy an Azure Automation Account and setup the Run As account as well as update the default modules.  It will then deploy a test PowerShell Desired State Configuration (DSC) to the Azure Automation account and then compile the DSC in Azure Automation via PowerShell Core, which will need to be installed locally or as part of a CI/CD task if executing in that context.  The last module is a bit contrived but it demonstrates how to apply the test DSC to a test virtual machine.  It should result in a green status in the Azure Automation account, similar to this figure.

Figure 1.

## Configuring the Sample
The sample leverages these Terraform and Azure capabilities to follow best practices:

1. Secrets and test certificates are stored in Key Vault
2. Terraform uses remote state
3. A .env file to provide values to variables vs. hard-coding values in the terraform code.

The next to sections cover setting up the above resources as well as configuring secrets in order to run the terraform in the folder root that leverages the modules.

## Update and import the .env file
Make a copy of `.env_sample` and customize the values.  At a minimum, you must configure the following variables for the sample to execute successfully:

```
TF_VAR_key_vault_name=
TF_VAR_backend_storage_account_name=
TF_VAR_backup_storage_account_name=
TF_VAR_AZURE_TENANT_ID=
TF_VAR_ARM_SUBSCRIPTION_ID=
TF_VAR_ARM_CLIENT_ID=
TF_VAR_ARM_CLIENT_SECRET=
TF_VAR_ARM_TENANT_ID=
```

___Note:__ provider.tf in the root directory uses remote state and has the pre-create-resource names hard-coded because terraform does not support variables in the provider.tf backend configuration section.  You will need to change ./provider.tf in the root folder to have the same value for the backend configuration property `storage_account_name` as the variable value set for `TF_VAR_backend_storage_account_name`._

Once the .env file is updated, import the variables from the Linux, Services for Linux, or macos command-line:

`set -o allexport && . .env && set +o allexport`

You will know that you've configured the .env correctly when you run `terraform plan` successfully without errors or prompting for a variable value.

## Execute the Pre-Create Terraform
With the .env environment variables properly loaded, run `terraform init`, `terraform plan` to check for issues, and then `terraform apply` in the pre-create-resources folder to create the Key Vault and Storage Account for remote state.

Upon successful completion, the next step is to configure Key Vault.

## Configure Secrets and Certificates in Key Vault
Once the pre-create-resoruces terraform code successfully completes, you can add the certificates and secrets:

Name | Type | Description
------ | ------|----------
AutomationRunAsAccountCert   | Certificate     | Certificate that needs to be a secret on the Automation Run As Account Service Principal as well as uploaded into the Azure Automation account.
       | 365   | (
b      |       | ^  

Certificates:
- 

Secrets:
AutomationRunAsAccountCert


run terraform init to setup remote state
run terraform plan
run terraform apply



The Azure Run As Certificate value should come from KeyVault.  It should be in state configured as an output variable so that it is available in this format:
data.azurerm_key_vault_secret.AutomationRunAsAccountCert.value
## Configure Key Vault
The following certificates and secrets need to be stored in Key Vault for Azure Automation RunAs Account:
1. AutomationRunAsAccountAppId - SECRET - App Registration Application ID for RunAs account
2. AutomationRunAsCertThumprint - SECRET - Certificate thumbprint for Azure RunAs Account
3. AutomationRunAsAccountCert - CERTIFICATE - Certfificate .pfx without password for Run As Service Principal.

## Get started with Desired State Configuration (DSC) for Windows
https://docs.microsoft.com/en-us/powershell/scripting/dsc/getting-started/winGettingStarted?view=powershell-7

## DSC in Azure Automation
https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started?view=powershell-7

## DSC Configurations
https://docs.microsoft.com/en-us/powershell/scripting/dsc/configurations/configurations?view=powershell-7

### Compiling DSCs to MOF:

> . .\dscConf1.ps1 dscConf1
> dscConf1
> Creates a folder named dscConf1 and places the compiled output as IsWebServer.mof, NotWebServer.mof

### Custom Modules

To incorporate unsigned modules you must set execution policy to bypass.

`Set-ExecutionPolicy -ExecutionPolicy Bypass  -Scope <scope>`

### Install Other Modules

Run in Windows Powershell Admin prompt for all modules identified in the script:

-> `Install-Module PowerStig -AllowClobber`
-> `Install-Module az -AllowClobber`

## Service Principal Certificates

To generate a self-signed certificate with OpenSSL use:
`openssl req -x509 -days 365 -newkey rsa:<bits> -keyout cert.pem -out cert.pem`
Replace "<bits>" with the number of bits you want to use, you should use 2048 or more.

This command converts the .pem to PKCS#12/PFX Format:
`openssl pkcs12 -export -in server-cert.pem -inkey cert.pem -out cert.pfx`

## Uploading and Compiling

Management:
Pull from master- I created a pull request when it was successful.

1. Import into Azure Automation: run (from your DSC working directory):
      `Import-AzAutomationDscConfiguration -AutomationAccountName "automationAccount"-ResourceGroupName "automation_rg" -SourcePath ".\DSC.ps1" -Force -Published`
2. Compile run (from the DSC working directory):
      `$config = Import-PowerShellDataFile .\DSC.shared.psd1`
      `Start-AzAutomationDscCompilationJob -ResourceGroupName 'AZ-DE-AFC-MADE-D-COR-RGP-01' -AutomationAccountName 'automationAccount' -ConfigurationName 'DSC' -ConfigurationData $config`

## Issues

1. Remove AzureRM provider using Add / Remove Programs
2. Run `Connect-AzAccount -Environment AzureUSGovernment` and `az login` to sign-in with PowerShell to Azure Government.  Note it times out faster for Azure Government.
3. You may get this warning after running `Connect-AzAccount`:
  * WARNING: Both Az and AzureRM modules were detected on this machine. Az and AzureRM modules cannot be imported in the same session or used in the same script or runbook. If you are running PowerShell in an environment you control you can use the 'Uninstall-AzureRm' cmdlet to remove all 
AzureRm modules from your machine. If you are running in Azure Automation, take care that none of your runbooks import both Az and AzureRM modules. More information can be found here: https://aka.ms/azps-migration-guide*

Run 'Uninstall-AzureRm' to fix the warning.
