variable "security_subscription_id" { type = string }
variable "connectivity_subscription_id" { type = string }
variable "management_subscription_id" { type = string }

variable "production_subscription_ids" {
  type    = list(string)
  default = []
}

variable "stage_subscription_ids" {
  type    = list(string)
  default = []
}

variable "sandbox_subscription_ids" {
  type    = list(string)
  default = []
}

variable "decommissioned_subscription_ids" {
  type    = list(string)
  default = []
}
