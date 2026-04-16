provider "azurerm" {
  features {}
  subscription_id = var.bootstrap_subscription_id
}

provider "azuread" {
  tenant_id = var.tenant_id
}
