variable "google_project" {}
variable "google_region" {}
variable "gcp_infra_provisionning_sa" {}
variable "key_name" {}
variable "keyring_name" {}


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

provider "google" {
  project = var.google_project
  region  = var.google_region
  impersonate_service_account = var.gcp_infra_provisionning_sa
  
}