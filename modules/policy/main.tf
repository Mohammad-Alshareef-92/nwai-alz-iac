locals {
  policy_allowed_locations         = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  policy_require_tag               = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  policy_allowed_vm_skus           = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
  policy_allowed_storage_skus      = "/providers/Microsoft.Authorization/policyDefinitions/7433c107-6db4-4ad1-b57a-a76dce0154a1"
  policy_not_allowed_resource_types = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
}

resource "azurerm_policy_set_definition" "core_governance" {
  name                = "nwai-core-governance"
  policy_type         = "Custom"
  display_name        = "NWAI Core Governance"
  description         = "Simple demo governance initiative."
  management_group_id = var.root_management_group_id

  parameters = jsonencode({
    allowedLocations = {
      type = "Array"
    }
    tagEnvironment = {
      type         = "String"
      defaultValue = "Environment"
    }
    tagOwner = {
      type         = "String"
      defaultValue = "Owner"
    }
    tagCostCenter = {
      type         = "String"
      defaultValue = "CostCenter"
    }
  })

  policy_definition_reference {
    policy_definition_id = local.policy_allowed_locations
    reference_id         = "allowed-locations"
    parameter_values = jsonencode({
      listOfAllowedLocations = { value = "[parameters('allowedLocations')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = local.policy_require_tag
    reference_id         = "require-environment-tag"
    parameter_values = jsonencode({
      tagName = { value = "[parameters('tagEnvironment')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = local.policy_require_tag
    reference_id         = "require-owner-tag"
    parameter_values = jsonencode({
      tagName = { value = "[parameters('tagOwner')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = local.policy_require_tag
    reference_id         = "require-costcenter-tag"
    parameter_values = jsonencode({
      tagName = { value = "[parameters('tagCostCenter')]" }
    })
  }
}

resource "azurerm_management_group_policy_assignment" "core" {
  name                 = "nwai-core-gov"
  display_name         = "NWAI Core Governance"
  policy_definition_id = azurerm_policy_set_definition.core_governance.id
  management_group_id  = var.root_management_group_id
  location             = var.allowed_locations[0]

  parameters = jsonencode({
    allowedLocations = { value = var.allowed_locations }
    tagEnvironment   = { value = "Environment" }
    tagOwner         = { value = "Owner" }
    tagCostCenter    = { value = "CostCenter" }
  })
}

resource "azurerm_management_group_policy_assignment" "sandbox_vm" {
  name                 = "nwai-sbx-vm-sku"
  display_name         = "NWAI Sandbox Allowed VM SKUs"
  policy_definition_id = local.policy_allowed_vm_skus
  management_group_id  = var.sandbox_management_group_id

  parameters = jsonencode({
    listOfAllowedSKUs = { value = var.sandbox_allowed_vm_skus }
  })
}

resource "azurerm_management_group_policy_assignment" "sandbox_storage" {
  name                 = "nwai-sbx-stgsku"
  display_name         = "NWAI Sandbox Allowed Storage SKUs"
  policy_definition_id = local.policy_allowed_storage_skus
  management_group_id  = var.sandbox_management_group_id

  parameters = jsonencode({
    listOfAllowedSKUs = { value = var.sandbox_allowed_storage_skus }
  })
}

resource "azurerm_management_group_policy_assignment" "decommissioned_no_public_ip" {
  name                 = "nwai-decom-pip"
  display_name         = "NWAI Decommissioned No Public IP"
  policy_definition_id = local.policy_not_allowed_resource_types
  management_group_id  = var.decommissioned_management_group_id

  parameters = jsonencode({
    listOfResourceTypesNotAllowed = {
      value = ["Microsoft.Network/publicIPAddresses"]
    }
  })
}
