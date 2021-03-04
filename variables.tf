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

variable "automation_account_tags" {
  description = "(Optiona) the tags for the resource"
  type        = string
  default     = "{}"
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

variable "dsc_config_name" {
  description = "(Required) Specifies the name of the DSC to deploy."
  type        = string
}

variable "dsc_config_path" {
  description = "(Required) Specifies the path to the DSC to deploy."
  type        = string
}