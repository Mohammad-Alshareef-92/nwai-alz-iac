output "group_names" {
  value = {
    platform_admins          = azuread_group.platform_admins.display_name
    global_readers           = azuread_group.global_readers.display_name
    security_contributors    = azuread_group.security_contributors.display_name
    network_contributors     = azuread_group.network_contributors.display_name
    management_contributors  = azuread_group.management_contributors.display_name
    landingzone_contributors = azuread_group.landingzone_contributors.display_name
    stage_contributors       = azuread_group.stage_contributors.display_name
    sandbox_contributors     = azuread_group.sandbox_contributors.display_name
  }
}