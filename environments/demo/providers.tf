provider "azurerm" {
  features {}
  subscription_id                 = var.bootstrap_subscription_id
  resource_provider_registrations = "none"
}

provider "azuread" {
  tenant_id = var.tenant_id
}
