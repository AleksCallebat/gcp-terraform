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
  region  = var.google_region

}

