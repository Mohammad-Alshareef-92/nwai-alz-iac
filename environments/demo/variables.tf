variable "tenant_id" {
  type = string
}

variable "bootstrap_subscription_id" {
  type = string
}

variable "online_subscription_ids" {
  type = list(string)

  validation {
    condition     = length(var.online_subscription_ids) > 0
    error_message = "online_subscription_ids must contain at least one subscription ID."
  }
}

variable "connectivity_subscription_ids" {
  type = list(string)

  validation {
    condition     = length(var.connectivity_subscription_ids) == 1
    error_message = "connectivity_subscription_ids must contain exactly one subscription ID because the management_groups module expects one connectivity subscription."
  }
}

variable "sandbox_subscription_ids" {
  type = list(string)

  validation {
    condition     = length(var.sandbox_subscription_ids) > 0
    error_message = "sandbox_subscription_ids must contain at least one subscription ID."
  }
}

variable "corp_subscription_ids" {
  type    = list(string)
  default = []
}

variable "production_subscription_ids" {
  type    = list(string)
  default = []
}

variable "stage_subscription_ids" {
  type    = list(string)
  default = []
}

variable "decommissioned_subscription_ids" {
  type    = list(string)
  default = []
}

variable "allowed_locations" {
  type    = list(string)
  default = ["uaenorth", "uaecentral", "eastus", "westus"]
}

variable "required_tags" {
  type    = list(string)
  default = ["Environment", "Owner", "CostCenter"]
}

variable "sandbox_allowed_vm_skus" {
  type    = list(string)
  default = ["Standard_B2s", "Standard_B2ms", "Standard_D2s_v5"]
}

variable "sandbox_allowed_storage_skus" {
  type    = list(string)
  default = ["Standard_LRS", "Standard_GRS"]
}

variable "group_prefix" {
  type    = string
  default = "nwai"
}
