


# create key ring
resource "google_kms_key_ring" "databricks_key_ring" {
  name     = var.keyring_name
  location = var.google_region
}

# create key used for encryption
resource "google_kms_crypto_key" "databricks_key" {
  name       = var.key_name
  key_ring   = google_kms_key_ring.databricks_key_ring.id
  purpose    = "ENCRYPT_DECRYPT"
  rotation_period = "31536000s" # Set rotation period to 1 year in seconds, need to be greater than 1 day
  
  # same key used for databricks managed and unmanaged storage
}

output "key_self_link" {
  value = google_kms_crypto_key.databricks_key.id
}

locals {
  cmek_resource_id = google_kms_crypto_key.databricks_key.id
}

resource "databricks_mws_customer_managed_keys" "this" {
        depends_on = [ google_kms_crypto_key.databricks_key ]
        provider = databricks.accounts
				account_id   = var.databricks_account_id
				gcp_key_info {
					kms_key_id   = local.cmek_resource_id # change this to var.cmek_resource_id if using a pre-created key
				}
				use_cases = ["STORAGE","MANAGED"]
        lifecycle {
              ignore_changes = all
        }
}

# Random suffix for databricks network and workspace
resource "random_string" "databricks_suffix" {
  special = false
  upper   = false
  length  = 2
}

resource "databricks_mws_workspaces" "databricks_workspace" {
  provider       = databricks.accounts
  account_id     = var.databricks_account_id
  workspace_name = var.workspace_name

  location = var.google_region
  cloud_resource_container {
    gcp {
      project_id = var.google_project
    }
  }

  network_id = databricks_mws_networks.databricks_network.network_id
  gke_config {
    connectivity_type = "PRIVATE_NODE_PUBLIC_MASTER"
    master_ip_range   = "10.3.0.0/28"
  }

  token {
    comment = "Terraform token"
  }
  storage_customer_managed_key_id = databricks_mws_customer_managed_keys.this.customer_managed_key_id


  # this makes sure that the NAT is created for outbound traffic before creating the workspace
  depends_on = [google_compute_router_nat.nat]
}


