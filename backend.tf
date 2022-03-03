terraform {
  backend "azurerm" {
    resource_group_name  = "JCKprojectfinaltest"
    storage_account_name = "jckprojectfinaltestsa"
    container_name       = "jckprojectfinaltestcon"
    key                  = "finaltest_key"
  }
}