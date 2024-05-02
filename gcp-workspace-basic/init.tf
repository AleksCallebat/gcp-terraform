terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "=1.24.0"

    }
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.google_project
  region  = var.google_region
  zone    = var.google_zone

}


// initialize provider in "accounts" mode to provision new workspace

provider "databricks" {
  alias                  = "accounts"  
  host                   = "https://accounts.gcp.databricks.com"
  google_service_account = var.databricks_google_service_account
  account_id             = var.databricks_account_id

}



data "google_client_openid_userinfo" "me" {
}


data "google_client_config" "current" {
}


resource "random_string" "suffix" {
  special = false
  upper   = false
  length  = 6
}

provider "databricks" {
  alias                  = "workspace"
  host                   = databricks_mws_workspaces.databricks_workspace.workspace_url
  google_service_account = var.databricks_google_service_account
}