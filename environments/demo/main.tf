module "management_groups" {
  source = "../../modules/management-groups"

  security_subscription_id        = var.security_subscription_id
  connectivity_subscription_id    = var.connectivity_subscription_id
  management_subscription_id      = var.management_subscription_id
  production_subscription_ids     = var.production_subscription_ids
  stage_subscription_ids          = var.stage_subscription_ids
  sandbox_subscription_ids        = var.sandbox_subscription_ids
  decommissioned_subscription_ids = var.decommissioned_subscription_ids
}

module "policy" {
  source = "../../modules/policy"

  root_management_group_id           = module.management_groups.root_id
  sandbox_management_group_id        = module.management_groups.sandbox_id
  decommissioned_management_group_id = module.management_groups.decommissioned_id

  allowed_locations            = var.allowed_locations
  required_tags                = var.required_tags
  sandbox_allowed_vm_skus      = var.sandbox_allowed_vm_skus
  sandbox_allowed_storage_skus = var.sandbox_allowed_storage_skus
}

module "rbac" {
  source = "../../modules/rbac"

  group_prefix = var.group_prefix

  root_management_group_id          = module.management_groups.root_id
  platform_management_group_id      = module.management_groups.platform_id
  landing_zones_management_group_id = module.management_groups.landing_zones_id
  stage_management_group_id         = module.management_groups.stage_id
  sandbox_management_group_id       = module.management_groups.sandbox_id

  security_subscription_id     = var.security_subscription_id
  connectivity_subscription_id = var.connectivity_subscription_id
  management_subscription_id   = var.management_subscription_id
}
