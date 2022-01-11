terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "shared-services"
    storage_account_name = "tomasiac"
    container_name       = "tfstate"
    key                  = "landingzone.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}
