variable "use_existing_key" {}

# create key ring
resource "google_kms_key_ring" "databricks_key_ring" {
    count = var.use_existing_key ? 0 : 1
    provider = google
    name     = var.keyring_name
    location = var.google_region
}

# create key used for encryption
resource "google_kms_crypto_key" "databricks_key" {
  count = var.use_existing_key ? 0 : 1
  provider = google
  name       = var.key_name
  key_ring   = google_kms_key_ring.databricks_key_ring[0].id
  purpose    = "ENCRYPT_DECRYPT"
  rotation_period = "31536000s" # Set rotation period to 1 year in seconds, need to be greater than 1 day

}

