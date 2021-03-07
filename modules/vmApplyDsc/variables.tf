variable "vm_resource_group" {
  description = "(Optional) Resource group name for the virtual machine where the DSC will be applied."
  type        = string
  default     = "vm_dsc_resource_group"
}

variable "location" {
  description = "(Required) Specifies the Azure region to create the resource."
  type        = string
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

variable "vm_name" {
  description = "(Optional) Virtual machine name where the DSC will be applied."
  type        = string
  default     = "vmtestapplydsc"
}

variable "vm_admin_password" {
  description = "(Required) Virtual maachine admin password."
  type        = string
  sensitive   = true
}

variable "vm_extension_name" {
  description = "(Optional) Name of the virtual machine extension.  Defaults to name of dsc for this example."
  type        = string
  default     = "dscWebServer"
}

variable "automation_account_access_key" {
  description = "(Required) The Automation Account Access Key required to enable the DSC extension on the virtual machine."
  type        = string
  sensitive   = true
}

variable "automation_account_dsc_server_endpoint" {
  description = "The Automation Account DSC server endpoint required to enable the DSC extension on the virtual machine."
  type        = string
}

variable "dsc_config_name" {
  description = "(Required) Specifies the name of the DSC to deploy."
  type        = string
}