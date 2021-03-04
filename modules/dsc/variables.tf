variable "resource_group_name" {
  description = "(Required) The name of the Resource Group for the Automatin Account"
  type        = string
}

variable "environment_tag" {
  description = "(Optiona) the tags for the resource"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "(Required) Specifies the Azure region to create the resource."
  type        = string
}

variable "automation_account_name" {
  description = "(Required) Specifies the name of the Automation Account."
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

variable "az_signin_appid" {
  description = "(Required) Specifies the appId used to sign-in to Azure."
  type        = string
  sensitive   = true
}

variable "az_signin_appid_pwd" {
  description = "(Required) Specifies the appId pwd used to sign-in to Azure."
  type        = string
  sensitive   = true
}

variable "cloud_environment" {
  description = "(Optional) Specifies the cloud environment to sign-in to from PowerShell."
  type = string
}


