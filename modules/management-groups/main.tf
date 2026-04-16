locals {
  corp_sub_map           = { for s in var.corp_subscription_ids : s => s }
  online_sub_map         = { for s in var.online_subscription_ids : s => s }
  stage_sub_map          = { for s in var.stage_subscription_ids : s => s }
  sandbox_sub_map        = { for s in var.sandbox_subscription_ids : s => s }
  decommissioned_sub_map = { for s in var.decommissioned_subscription_ids : s => s }
}

resource "azurerm_management_group" "root" {
  display_name = "NWAI Root"
  name         = "nwai-root"
}

# ── Platform ─────────────────────────────────────────────────────────────────

resource "azurerm_management_group" "platform" {
  display_name               = "NWAI Platform"
  name                       = "nwai-platform"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "management" {
  display_name               = "NWAI Management"
  name                       = "nwai-management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "connectivity" {
  display_name               = "NWAI Connectivity"
  name                       = "nwai-connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "identity" {
  display_name               = "NWAI Identity"
  name                       = "nwai-identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

# ── Landing Zones ─────────────────────────────────────────────────────────────

resource "azurerm_management_group" "landing_zones" {
  display_name               = "NWAI Landing Zones"
  name                       = "nwai-landing-zones"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "corp" {
  display_name               = "NWAI Corp"
  name                       = "nwai-corp"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "online" {
  display_name               = "NWAI Online"
  name                       = "nwai-online"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

# ── Other ─────────────────────────────────────────────────────────────────────

resource "azurerm_management_group" "stage" {
  display_name               = "NWAI Stage"
  name                       = "nwai-stage"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "sandbox" {
  display_name               = "NWAI Sandbox"
  name                       = "nwai-sandbox"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "decommissioned" {
  display_name               = "NWAI Decommissioned"
  name                       = "nwai-decommissioned"
  parent_management_group_id = azurerm_management_group.root.id
}

# ── Subscription Associations ─────────────────────────────────────────────────

resource "azurerm_management_group_subscription_association" "management" {
  count               = var.management_subscription_id != "" ? 1 : 0
  management_group_id = azurerm_management_group.management.id
  subscription_id     = "/subscriptions/${var.management_subscription_id}"
}

resource "azurerm_management_group_subscription_association" "connectivity" {
  management_group_id = azurerm_management_group.connectivity.id
  subscription_id     = "/subscriptions/${var.connectivity_subscription_id}"
}

resource "azurerm_management_group_subscription_association" "security" {
  count               = var.security_subscription_id != "" ? 1 : 0
  management_group_id = azurerm_management_group.identity.id
  subscription_id     = "/subscriptions/${var.security_subscription_id}"
}

resource "azurerm_management_group_subscription_association" "corp" {
  for_each            = local.corp_sub_map
  management_group_id = azurerm_management_group.corp.id
  subscription_id     = "/subscriptions/${each.value}"
}

resource "azurerm_management_group_subscription_association" "online" {
  for_each            = local.online_sub_map
  management_group_id = azurerm_management_group.online.id
  subscription_id     = "/subscriptions/${each.value}"
}

resource "azurerm_management_group_subscription_association" "stage" {
  for_each            = local.stage_sub_map
  management_group_id = azurerm_management_group.stage.id
  subscription_id     = "/subscriptions/${each.value}"
}

resource "azurerm_management_group_subscription_association" "sandbox" {
  for_each            = local.sandbox_sub_map
  management_group_id = azurerm_management_group.sandbox.id
  subscription_id     = "/subscriptions/${each.value}"
}

resource "azurerm_management_group_subscription_association" "decommissioned" {
  for_each            = local.decommissioned_sub_map
  management_group_id = azurerm_management_group.decommissioned.id
  subscription_id     = "/subscriptions/${each.value}"
}
