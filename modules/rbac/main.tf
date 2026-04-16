resource "azuread_group" "platform_admins" {
  display_name     = "${var.group_prefix}-platform-admins"
  security_enabled = true
}

resource "azuread_group" "global_readers" {
  display_name     = "${var.group_prefix}-global-readers"
  security_enabled = true
}

resource "azuread_group" "security_contributors" {
  display_name     = "${var.group_prefix}-security-contributors"
  security_enabled = true
}

resource "azuread_group" "network_contributors" {
  display_name     = "${var.group_prefix}-network-contributors"
  security_enabled = true
}

resource "azuread_group" "management_contributors" {
  display_name     = "${var.group_prefix}-management-contributors"
  security_enabled = true
}

resource "azuread_group" "landingzone_contributors" {
  display_name     = "${var.group_prefix}-landingzone-contributors"
  security_enabled = true
}

resource "azuread_group" "stage_contributors" {
  display_name     = "${var.group_prefix}-stage-contributors"
  security_enabled = true
}

resource "azuread_group" "sandbox_contributors" {
  display_name     = "${var.group_prefix}-sandbox-contributors"
  security_enabled = true
}

resource "azurerm_role_assignment" "platform_admins_owner" {
  scope                = var.platform_management_group_id
  role_definition_name = "Owner"
  principal_id         = azuread_group.platform_admins.object_id
}

resource "azurerm_role_assignment" "global_readers_reader" {
  scope                = var.root_management_group_id
  role_definition_name = "Reader"
  principal_id         = azuread_group.global_readers.object_id
}

resource "azurerm_role_assignment" "security_contributor" {
  scope                = "/subscriptions/${var.security_subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_group.security_contributors.object_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = "/subscriptions/${var.connectivity_subscription_id}"
  role_definition_name = "Network Contributor"
  principal_id         = azuread_group.network_contributors.object_id
}

resource "azurerm_role_assignment" "management_contributor" {
  scope                = "/subscriptions/${var.management_subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_group.management_contributors.object_id
}

resource "azurerm_role_assignment" "landingzone_contributor" {
  scope                = var.landing_zones_management_group_id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.landingzone_contributors.object_id
}

resource "azurerm_role_assignment" "stage_contributor" {
  scope                = var.stage_management_group_id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.stage_contributors.object_id
}

resource "azurerm_role_assignment" "sandbox_contributor" {
  scope                = var.sandbox_management_group_id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.sandbox_contributors.object_id
}