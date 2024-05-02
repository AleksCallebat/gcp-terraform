terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = ">=1.39.0"

    }
    google = {
      source  = "hashicorp/google"
    }

  }
}
provider "google" {
  project = var.project
  impersonate_service_account = var.databricks_google_service_account

}


provider "databricks" {
  alias      = "accounts"
  host       = "https://accounts.gcp.databricks.com"
  google_service_account = var.databricks_google_service_account
  account_id = var.databricks_account_id
}