output "management_groups" {
  value = module.management_groups
}

output "rbac_groups" {
  value = module.rbac.group_names
}
