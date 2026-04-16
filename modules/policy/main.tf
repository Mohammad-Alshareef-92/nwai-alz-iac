data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

data "azurerm_policy_definition" "require_tag" {
  display_name = "Require a tag on resources"
}

data "azurerm_policy_definition" "allowed_vm_skus" {
  display_name = "Allowed virtual machine size SKUs"
}

data "azurerm_policy_definition" "allowed_storage_skus" {
  display_name = "Allowed storage account SKUs"
}

data "azurerm_policy_definition" "not_allowed_resource_types" {
  display_name = "Not allowed resource types"
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
    policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
    reference_id         = "allowed-locations"
    parameter_values = jsonencode({
      listOfAllowedLocations = { value = "[parameters('allowedLocations')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = data.azurerm_policy_definition.require_tag.id
    reference_id         = "require-environment-tag"
    parameter_values = jsonencode({
      tagName = { value = "[parameters('tagEnvironment')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = data.azurerm_policy_definition.require_tag.id
    reference_id         = "require-owner-tag"
    parameter_values = jsonencode({
      tagName = { value = "[parameters('tagOwner')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = data.azurerm_policy_definition.require_tag.id
    reference_id         = "require-costcenter-tag"
    parameter_values = jsonencode({
      tagName = { value = "[parameters('tagCostCenter')]" }
    })
  }
}

resource "azurerm_management_group_policy_assignment" "core" {
  name                 = "nwai-core-governance"
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
  name                 = "nwai-sandbox-allowed-vm-skus"
  display_name         = "NWAI Sandbox Allowed VM SKUs"
  policy_definition_id = data.azurerm_policy_definition.allowed_vm_skus.id
  management_group_id  = var.sandbox_management_group_id

  parameters = jsonencode({
    listOfAllowedSKUs = { value = var.sandbox_allowed_vm_skus }
  })
}

resource "azurerm_management_group_policy_assignment" "sandbox_storage" {
  name                 = "nwai-sandbox-allowed-storage-skus"
  display_name         = "NWAI Sandbox Allowed Storage SKUs"
  policy_definition_id = data.azurerm_policy_definition.allowed_storage_skus.id
  management_group_id  = var.sandbox_management_group_id

  parameters = jsonencode({
    listOfAllowedSKUs = { value = var.sandbox_allowed_storage_skus }
  })
}

resource "azurerm_management_group_policy_assignment" "decommissioned_no_public_ip" {
  name                 = "nwai-decommissioned-no-public-ip"
  display_name         = "NWAI Decommissioned No Public IP"
  policy_definition_id = data.azurerm_policy_definition.not_allowed_resource_types.id
  management_group_id  = var.decommissioned_management_group_id

  parameters = jsonencode({
    listOfResourceTypesNotAllowed = {
      value = ["Microsoft.Network/publicIPAddresses"]
    }
  })
}
