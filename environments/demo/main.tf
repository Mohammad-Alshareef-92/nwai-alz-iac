module "management_groups" {
  source = "../../modules/management-groups"

  connectivity_subscription_id    = local.connectivity_subscription_id
  online_subscription_ids         = [local.online_subscription_id]
  sandbox_subscription_ids        = [local.sandbox_subscription_id]

  # No subscriptions for management or identity in this environment
  decommissioned_subscription_ids = var.decommissioned_subscription_ids
  stage_subscription_ids          = var.stage_subscription_ids
  corp_subscription_ids           = var.corp_subscription_ids
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
  management_management_group_id    = module.management_groups.management_id
  connectivity_management_group_id  = module.management_groups.connectivity_id
  identity_management_group_id      = module.management_groups.identity_id
  landing_zones_management_group_id = module.management_groups.landing_zones_id
  corp_management_group_id          = module.management_groups.corp_id
  online_management_group_id        = module.management_groups.online_id
  stage_management_group_id         = module.management_groups.stage_id
  sandbox_management_group_id       = module.management_groups.sandbox_id
}
