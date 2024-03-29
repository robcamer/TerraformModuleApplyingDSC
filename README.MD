# Terraform, Azure Automation, and apply a DSC to a Virtual Machine

## Overview

This example consists of an example that leverages three terraform modules located in the modules folder:

1. automationAccount
2. dsc
3. vmApplyDsc

Running this example will deploy an Azure Automation Account and setup the Run As account as well as update the default modules.  It will then deploy a test PowerShell Desired State Configuration (DSC) to the Azure Automation account and then compile the DSC in Azure Automation via PowerShell Core, which will need to be installed locally or as part of a CI/CD task if executing in that context.  The last module is a bit contrived but it demonstrates how to apply the test DSC to a test virtual machine.  It should result in a green status in the Azure Automation account under "State configuration (DSC)", similar to this figure.

![DSC Applied to Virtual Machine](./src/img/AutomationAccountDSCAppliedToVM.png)

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

Once the .env file is updated, import the variables from the Linux, Services for Linux, or MacOS command-line:

`set -o allexport && . .env && set +o allexport`

You will know that you've configured the .env correctly when you run `terraform plan` successfully without errors or prompting for a variable value.

## Execute the Pre-Create Terraform

With the .env environment variables properly loaded, run `terraform init`, `terraform plan` to check for issues, and then `terraform apply` in the pre-create-resources folder to create the Key Vault and Storage Account for remote state.

Upon successful completion, the next step is to configure Key Vault.

## Configure Secrets and Certificates in Key Vault

Once the pre-create-resoruces terraform code successfully completes, you can add the certificates and secrets:

Name | Type | Description
------ | ------|----------
AutomationRunAsAccountCert   | Certificate | Certificate that needs to be a secret on the Automation Run As Account Service Principal as well as uploaded into the Azure Automation account.
  ApplyDscTestVmPassword     | Secret | Admin password for the virtual machine.
AutomationRunAsAccountAppId  | Secret | AAD Service Principal App Id configured on the Azure Automation Run As account.
AutomationRunAsAccountAppSecret | Secret | AAD Service Principal App password configured on the Azure Automation Run As account.

![Key Vault Certificate](./src/img/keyvault_certificate.png)

![Key Vault Secrets](./src/img/keyvault_secrets.png)

## Run the Sample
Once the above steps are completed, you are ready to run the sample by going to the root folder and executing the following commands:

```
terraform init
terraform plan
terraform apply
```

# References

Here are some references that may be helpful when looking for more information on the Automation Account and DSC.

## Get started with Desired State Configuration (DSC) for Windows

https://docs.microsoft.com/en-us/powershell/scripting/dsc/getting-started/winGettingStarted?view=powershell-7

## DSC in Azure Automation

https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started?view=powershell-7

## DSC Configurations

https://docs.microsoft.com/en-us/powershell/scripting/dsc/configurations/configurations?view=powershell-7

### Compiling DSCs to MOF:

Here are steps to compile a DSC locally:

> . .\dscWebServer.ps1 dscConf1
> dscWebServer
> Creates a folder named dscWebServer and places the compiled output as IsWebServer.mof, NotWebServer.mof

### Custom Modules

To incorporate unsigned modules you must set execution policy to bypass.

`Set-ExecutionPolicy -ExecutionPolicy Bypass  -Scope <scope>`

### Install Other Modules

Run in Windows Powershell Admin prompt for all modules identified in the script:

-> `Install-Module PowerStig -AllowClobber`
-> `Install-Module az -AllowClobber`

## Service Principal Certificates

You can have Key Vault generate the correct certificate for you, which is recommended.  To generate a self-signed certificate with OpenSSL use this command:

`openssl req -x509 -days 365 -newkey rsa:<bits> -keyout cert.pem -out cert.pem`

Replace "<bits>" with the number of bits you want to use.  It is recommended to se 2048 or more.

This command converts the .pem to PKCS#12/PFX Format:

`openssl pkcs12 -export -in server-cert.pem -inkey cert.pem -out cert.pfx`
