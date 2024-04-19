provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
  #skip_provider_registration = true
}

