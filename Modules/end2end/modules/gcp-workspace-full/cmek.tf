# create key ring
resource "google_kms_key_ring" "databricks_key_ring" {
    provider = google.deployment
    count = var.use_existing_key ? 0 : 1
    name     = var.keyring_name
    location = var.google_region
    depends_on = [ module.dbx-admin-grant,module.sa-provisionning ]
    
}

# create key used for encryption
resource "google_kms_crypto_key" "databricks_key" {
  count = var.use_existing_key ? 0 : 1
  provider = google.deployment
  name       = var.key_name
  key_ring   = google_kms_key_ring.databricks_key_ring[0].id
  purpose    = "ENCRYPT_DECRYPT"
  rotation_period = "31536000s" # Set rotation period to 1 year in seconds, need to be greater than 1 day
  depends_on = [ module.dbx-admin-grant,module.sa-provisionning ]

}

# # assign CMEK on Databricks side

resource "databricks_mws_customer_managed_keys" "this" {
        provider = databricks.accounts
        depends_on = [ module.dbx-admin-grant,module.sa-provisionning ]
        account_id   = var.databricks_account_id
        gcp_key_info {
            kms_key_id   = var.use_existing_key ? var.cmek_resource_id : google_kms_crypto_key.databricks_key[0].id
        }
        use_cases = ["STORAGE","MANAGED","MANAGED_SERVICES"]
        lifecycle {
              ignore_changes = all
        }
}