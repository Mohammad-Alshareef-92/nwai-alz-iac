variable "connectivity_subscription_id" { type = string }

variable "security_subscription_id" {
  type    = string
  default = ""
}

variable "management_subscription_id" {
  type    = string
  default = ""
}

variable "corp_subscription_ids" {
  type    = list(string)
  default = []
}

variable "online_subscription_ids" {
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
