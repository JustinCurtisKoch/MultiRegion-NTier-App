# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.95.0"
    }
  }
}

#Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
    subscription_id = "8d12a595-ad13-41df-bf17-0a5b9ad7aa90"
  client_id       = "bba2906c-68e8-408d-8061-6358ca4d3c37"
  client_secret   = "gA57Q~nNvfxTjafqOohxnnoY.zuFZhDHPpckl"
  tenant_id       = "33da9f3f-4c1a-4640-8ce1-3f63024aea1d"
}