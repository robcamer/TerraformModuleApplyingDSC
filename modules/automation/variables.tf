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

variable "environment_tag" {
  description = "(Optiona) the tags for the resource"
  type        = set(string)
  default     = null
}

variable "automation_run_as_certificate_name" {
  description = "(Optional) The name of the Run As Certificate to configure in the Automation Account."
  type        = string
  default     = "AzureRunAsCertificate"
}
