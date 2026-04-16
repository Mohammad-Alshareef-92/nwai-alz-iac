locals {
  prod_sub_map           = { for s in var.production_subscription_ids : s => s }
  stage_sub_map          = { for s in var.stage_subscription_ids : s => s }
  sandbox_sub_map        = { for s in var.sandbox_subscription_ids : s => s }
  decommissioned_sub_map = { for s in var.decommissioned_subscription_ids : s => s }
}

resource "azurerm_management_group" "root" {
  display_name = "NWAI Root"
  name         = "nwai-root"
}

resource "azurerm_management_group" "platform" {
  display_name               = "NWAI Platform"
  name                       = "nwai-platform"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "landing_zones" {
  display_name               = "NWAI Landing Zones"
  name                       = "nwai-landing-zones"
  parent_management_group_id = azurerm_management_group.root.id
}

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

resource "azurerm_management_group_subscription_association" "security" {
  management_group_id = azurerm_management_group.platform.id
  subscription_id     = "/subscriptions/${var.security_subscription_id}"
}

resource "azurerm_management_group_subscription_association" "connectivity" {
  management_group_id = azurerm_management_group.platform.id
  subscription_id     = "/subscriptions/${var.connectivity_subscription_id}"
}

resource "azurerm_management_group_subscription_association" "management" {
  management_group_id = azurerm_management_group.platform.id
  subscription_id     = "/subscriptions/${var.management_subscription_id}"
}

resource "azurerm_management_group_subscription_association" "production" {
  for_each            = local.prod_sub_map
  management_group_id = azurerm_management_group.landing_zones.id
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
