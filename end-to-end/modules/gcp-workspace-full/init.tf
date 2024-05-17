variable "google_project_name" {}
variable "google_region" {}
variable "google_shared_vpc_project" {}
variable "delegate_from" {}
variable "role_name" {}
variable "old_admin_account" {}
variable "priviledged_sa_name" {}
variable "random_string" {
  default = "random_string"
}


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

module "sa-provisionning" {
  source = "../sa-provisionning"
  google_project = var.google_project_name
  delegate_from = var.delegate_from
  role_name = "${var.role_name}_${var.random_string}"
  google_region = var.google_region
  priviledged_sa_name = "${var.priviledged_sa_name}-${var.random_string}"
}

module "dbx-admin-grant" {
    source ="../dbx-admin-grant"
    old_admin_account = var.old_admin_account
    new_admin_account = module.sa-provisionning.service_account
    databricks_account_id = var.databricks_account_id
}

provider "databricks" {
  alias                  = "accounts"
  host                   = "https://accounts.gcp.databricks.com"
  google_service_account =  module.sa-provisionning.service_account
  # google_service_account = var.old_admin_account
  account_id = var.databricks_account_id
}

provider "databricks" {
  alias                  = "workspace2"
  host                   = databricks_mws_workspaces.databricks_workspace.workspace_url
  google_service_account = module.sa-provisionning.service_account
}

provider "google" {
  alias = "deployment"
  project = var.google_project_name
  region  = var.google_region
  impersonate_service_account = module.sa-provisionning.service_account
  
}