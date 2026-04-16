output "root_id" {
  value = azurerm_management_group.root.id
}

output "platform_id" {
  value = azurerm_management_group.platform.id
}

output "landing_zones_id" {
  value = azurerm_management_group.landing_zones.id
}

output "stage_id" {
  value = azurerm_management_group.stage.id
}

output "sandbox_id" {
  value = azurerm_management_group.sandbox.id
}

output "decommissioned_id" {
  value = azurerm_management_group.decommissioned.id
}
