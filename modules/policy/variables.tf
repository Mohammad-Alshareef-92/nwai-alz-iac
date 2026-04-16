variable "root_management_group_id" { type = string }
variable "sandbox_management_group_id" { type = string }
variable "decommissioned_management_group_id" { type = string }

variable "allowed_locations" {
  type = list(string)
}

variable "required_tags" {
  type = list(string)
}

variable "sandbox_allowed_vm_skus" {
  type = list(string)
}

variable "sandbox_allowed_storage_skus" {
  type = list(string)
}
