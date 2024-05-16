# LOGIC OF THE FILE : IF THERE IS A DATABRICKS METASTORE, ATTACH THE WORKSPACE TO IT. IF NOT, CREATE THE METASTORE AND ATTACH THE WORKSPACE

# CREATE GOOGLE STORAGE FOR THE METASTORE
resource "google_storage_bucket" "unity_metastore" {
  name          = var.uc_storage_name
  location      = var.google_region
  force_destroy = true
}

# # CHECK IF DATABRICKS METASTORE EXISTS
data "databricks_metastore" "existing_metastore" {
  count = var.metastore_exists ? 1 : 0
  provider = databricks.accounts
  name = var.metastore_name
}
# IF NOT, CREATE THE METASTORE
resource "databricks_metastore" "this" {
  count = var.metastore_exists ? 0 : 1
  provider      = databricks.accounts
  name          = var.metastore_name
  region        = var.google_region
  force_destroy = true
    storage_root  = "gs://${google_storage_bucket.unity_metastore.name}"
}

resource "databricks_metastore_data_access" "first" {
  provider     = databricks.accounts
  metastore_id = var.metastore_exists?data.databricks_metastore.existing_metastore[0].id:databricks_metastore.this[0].id
  databricks_gcp_service_account {}
  name       = "storage-credentials" // storage credentials created for the default storage account
  is_default = true
}
# ADD WORKSPACE TO THE METASTORE
resource "databricks_metastore_assignment" "this" {
  provider             = databricks.accounts
  workspace_id         = module.gcp-workspace-full.workspace_id
  metastore_id         = var.metastore_exists?data.databricks_metastore.existing_metastore[0].id:databricks_metastore.this[0].id
  default_catalog_name = "${module.gcp-workspace-full.workspace_name}-main"
}
