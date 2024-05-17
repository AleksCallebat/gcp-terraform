# LOGIC OF THE FILE : IF THERE IS A DATABRICKS METASTORE, ATTACH THE WORKSPACE TO IT. IF NOT, CREATE THE METASTORE AND ATTACH THE WORKSPACE

# CREATE GOOGLE STORAGE FOR THE METASTORE
resource "google_storage_bucket" "unity_metastore" {
  count = var.metastore_exists ? 0 : 1
  provider = google.deployed
  depends_on = [ module.gcp-workspace-full ]
  name          = var.uc_storage_name
  location      = var.google_region
  force_destroy = true
}

# # CHECK IF DATABRICKS METASTORE EXISTS
data "databricks_metastore" "existing_metastore" {
  count = var.metastore_exists ? 1 : 0
  depends_on = [ module.gcp-workspace-full ]
  provider = databricks.accounts
  name = var.metastore_name
}

# IF NOT, CREATE THE METASTORE
resource "databricks_metastore" "new_metastore" {
  depends_on = [ module.gcp-workspace-full ]
  count = var.metastore_exists ? 0 : 1
  provider      = databricks.accounts
  name          = var.metastore_name
  region        = var.google_region
  force_destroy = true
    storage_root  = "gs://${google_storage_bucket.unity_metastore[0].name}"
}


# CREATE STORAGE CREDENTIALS
resource "databricks_metastore_data_access" "first" {
  count = var.metastore_exists ? 0 : 1
  provider     = databricks.accounts
  metastore_id = var.metastore_exists?data.databricks_metastore.existing_metastore[0].id:databricks_metastore.new_metastore[0].id
  databricks_gcp_service_account {}
  name       = "storage-credentials-uc" // storage credentials created for the default storage account
  is_default = true
}

# ADD WORKSPACE TO THE METASTORE
resource "databricks_metastore_assignment" "this" {
  provider             = databricks.accounts
  workspace_id         = module.gcp-workspace-full.workspace_id
  metastore_id         = var.metastore_exists?data.databricks_metastore.existing_metastore[0].id:databricks_metastore.new_metastore[0].id
  default_catalog_name = "${module.gcp-workspace-full.workspace_name}-main"
}

resource "databricks_group" "workspace_users"{
  depends_on = [ module.gcp-workspace-full ]
  provider = databricks.accounts
  display_name = "workspace users"
  allow_cluster_create = true
  allow_instance_pool_create = true
}

locals {
  user_emails = toset(var.workspace_users)
}
resource "databricks_user" "workspace_users"{
  provider = databricks.accounts
  depends_on = [ module.gcp-workspace-full ]
  for_each = local.user_emails
  user_name = each.value
}
resource "databricks_group_member" "engineer-admins"{
  provider = databricks.accounts
  group_id = databricks_group.workspace_users.id
  for_each = local.user_emails
  member_id = databricks_user.workspace_users[each.key].id
}