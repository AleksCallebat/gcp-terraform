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
  project = var.google_project
}
provider "databricks" {
  host       = "https://accounts.gcp.databricks.com"
  google_service_account = var.dbx_existing_admin_account
  account_id = var.databricks_account_id

}