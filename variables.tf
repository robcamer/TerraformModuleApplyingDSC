variable "location" {
  description = "(Required) Specifies the Azure region to create the resource."
  type        = string
}

variable "automation_account_name" {
  description = "(Required) Specifies the name of the Automation Account"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group for the Automatin Account"
  type        = string
}

variable "automation_run_as_certificate_name" {
  description = "(Optional) The name of the Run As Certificate to configure in the Automation Account."
  type        = string
  default     = "AzureRunAsCertificate"
}

variable "environment_tag" {
  description = "(Optional) Tag values."
  type        = string
  default     = "dev"
}

variable "pre_resource_group_name" {
  description = "(Required) The name of the resource to deploy key vault."
  type        = string
}

variable "key_vault_name" {
  description = "(Required) Name of the key vault."
  type        = string
}

variable "dsc_name" {
  description = "(Required) Specifies the name of the DSC to deploy."
  type        = string
}

variable "dsc_config_name" {
  description = "(Required) Specifies the name of the DSC configuraiton to apply on the virtual machine."
  type        = string
}

variable "dsc_path" {
  description = "(Required) Specifies the path to the DSC to deploy."
  type        = string
}

variable "CLOUD_ENVIRONMENT" {
  description = "(Optional) Specifies the cloud environment to sign-in to from PowerShell."
  type        = string
  default     = "AzureCloud"
}

variable "ARM_TENANT_ID" {
  description = "(Required) Specifies Azure Tenant ID."
  type        = string
}

variable "vm_extension_name" {
  description = "(Optional) Name of the virtual machine extension.  Defaults to name of dsc for this example."
  type        = string
  default     = "dscWebServer"
}

variable "vm_name" {
  description = "(Optional) Virtual machine name where the DSC will be applied."
  type        = string
  default     = "vmtestapplydsc"
}

variable "vm_vnet_name" {
  description = "(Optional) Virtual network name for the virtual machine."
  type        = string
  default     = "vmvnetdsc"
}

variable "vm_subnet_name" {
  description = "(Optional) Virtual network subnet name for the virtual machine."
  type        = string
  default     = "vmvnetsubnetdsc"
}