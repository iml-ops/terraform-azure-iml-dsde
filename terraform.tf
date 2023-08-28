terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "cdbddd34-8cc5-4a43-9a51-2cf92e9c35f5"
}
