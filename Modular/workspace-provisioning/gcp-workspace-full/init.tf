variable "google_project_name" {}
variable "google_region" {}
variable "google_shared_vpc_project" {}
variable "workspace_creator_sa_name" {}



terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = ">=1.24.0"
    }
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "databricks" {
  alias                  = "accounts"
  host                   = "https://accounts.gcp.databricks.com"
  google_service_account =  var.workspace_creator_sa_name
  account_id = var.databricks_account_id
}

provider "databricks" {
  alias                  = "workspace"
  host                   = databricks_mws_workspaces.databricks_workspace.workspace_url
  google_service_account = var.workspace_creator_sa_name
}

provider "google" {
  project = var.google_project_name
  region  = var.google_region
  impersonate_service_account = var.workspace_creator_sa_name
  
}