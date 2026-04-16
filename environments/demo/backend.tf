terraform {
  backend "azurerm" {
    resource_group_name  = "rg-nwai-tofu-state"
    storage_account_name = "nwaitofustate001"
    container_name       = "tfstate"
    key                  = "demo.terraform.tfstate"
  }
}
