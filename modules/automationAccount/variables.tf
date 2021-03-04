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

variable "subscriptionId" {
  description = "(Required) The subscription Id for the subscription."
  type        = string
}

variable "tenantId" {
  description = "(Required) The AAD Tenant Id for the subscription."
  type        = string
}

variable "automation_account_name" {
  description = "(Required) Specifies the name of the Automation Account"
  type        = string
}

variable "automation_run_as_certificate_name" {
  description = "(Optional) The name of the Run As Certificate to configure in the Automation Account."
  type        = string
  default     = "AzureRunAsCertificate"
}

variable "automation_run_as_appid" {
  description = "(Required) The service principal app Id for the Automation RunAs account"
  type        = string
}

variable "automation_run_as_certificate_thumbprint" {
  description = "(Required) The certificate thumbprint of the configured Run As Certificate in the Automation Account."
  type        = string
}

variable "automation_run_as_connection_name" {
  description = "(Optional) The subscription Id for the subscription."
  type        = string
  default     = "AzureRunAsConnection"
}

variable "automation_run_as_connection_type" {
  description = "(Optional) The subscription Id for the subscription."
  type        = string
  default     = "AzureServicePrincipal"
}

variable "automation_run_as_account_cert" {
  description = "(Required) The Automation Account Run As Certificate, in .pfx format without a password."
  type        = string
}

