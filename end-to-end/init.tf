terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
    databricks = {
      source = "databricks/databricks"
      version = ">=0.3.9"
    
    }
  }
}

provider "google" {
  alias = "deployed"
  impersonate_service_account = module.gcp-workspace-full.service_account
  project = var.google_project
  region  = var.google_region

}

provider "databricks" {
  alias = "workspace"
  host = module.gcp-workspace-full.workspace_url
  google_service_account = module.gcp-workspace-full.service_account
  account_id = var.databricks_account_id
  
}

provider "databricks" {
  alias = "accounts"
  host = "https://accounts.gcp.databricks.com"
  google_service_account = module.gcp-workspace-full.service_account
  account_id = var.databricks_account_id
}

