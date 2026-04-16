data "azurerm_subscriptions" "available" {}

locals {
  subs_by_name = {
    for s in data.azurerm_subscriptions.available.subscriptions : s.display_name => s.subscription_id
  }

  online_subscription_id       = local.subs_by_name["azure-learning-path-pay-as-you-go"]
  connectivity_subscription_id = local.subs_by_name["connectivity"]
  sandbox_subscription_id      = local.subs_by_name["dev-subs"]
}
