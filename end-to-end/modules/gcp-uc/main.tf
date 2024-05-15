## ADD SEPARATE UC SCRIPT JUST FOR METASTORE PROVISIONNING

# ADD A GROUP (BU-LEVEL) OF USERS TO THE METASTORE


# ADD 3 CATALOGS (Dev, PreProd, Prd)

# ADD A METASTORE ADMIN


# ANY NEW WS CAN BE ADDED HERE. ON NEW WS IN THE METASTORE, METASTORE ADMIN GETS WORKSPACE ADMIN RIGHTS


# ADD A USER TO THE METASTORE
resource "databricks_user" "admin_member0" { 
  provider     = databricks.accounts
  user_name = var.admin_user
}

# CREATE GOOGLE STORAGE FOR THE METASTORE
resource "google_storage_bucket" "unity_metastore" {
  name          = var.storage_name
  location      = var.location
  force_destroy = true
}

# CREATE METASTORE - SHOULD ALREADY BE DONE
resource "databricks_metastore" "this" {
  provider      = databricks.accounts
  name          = var.metastore_name
  region        = var.location
  force_destroy = true
    storage_root  = "gs://${google_storage_bucket.unity_metastore.name}"
}

# ADD EXTERNAL ACCESS CREDENTIALS TO THE METASTORE
resource "databricks_metastore_data_access" "first" {
  provider     = databricks.accounts
  metastore_id = databricks_metastore.this.id
  databricks_gcp_service_account {}
  name       = "storage-credentials" // storage credentials created for the default storage account
  is_default = true
}

# ADD WORKSPACE TO THE METASTORE
resource "databricks_metastore_assignment" "this" {
  provider             = databricks.accounts
  workspace_id         = var.databricks_workspace_id
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "${var.workspace_name}-main"
}

# GRANT ADMIN USER ACCESS TO THE WORKSPACE
resource "databricks_mws_permission_assignment" "add_admin_group" {
  provider = databricks.accounts
  workspace_id = var.databricks_workspace_id 
  principal_id = databricks_user.admin_member0.id
  permissions  = ["ADMIN"]
}


resource "databricks_user" "sa" {
  provider = databricks.accounts
  display_name         = "Alek - TF - TEST"
  user_name = "alek-tf-test@example.com"
}
resource "databricks_user_role" "my_user_account_admin" {
  provider = databricks.accounts 
  user_id = databricks_user.sa.id
  role    = "account_admin"
}

