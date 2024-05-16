variable "databricks_account_id" {}
variable "databricks_account_console_url" {}
variable "databricks_workspace_name" {}
variable "databricks_user_email" {}
variable "google_vpc_id" {}
variable "node_subnet_name" {}
variable "pod_subnet_name" {}
variable "service_subnet_name" {}
variable "gke_master_ip_range" {}
variable "cmek_resource_id" {}
variable "network_config_name" {}

data "google_client_openid_userinfo" "me" {}
data "google_client_config" "current" {}

/*
Service account attached to the GKE cluster to spin up GKE nodes
GKE node pool use this service account to call Google Cloud APIs
instead of using the default compute engine SA, databricks will use this SA
this is different than the workload identity aka SA that you'll use to connect to your data sources as explained here
https://docs.gcp.databricks.com/archive/compute/configure.html#google-service-account
*/


data "google_service_account" "databricks" {
    account_id   = "databricks" #need to use "databricks"
    # display_name = "Databricks SA for GKE nodes"
    project = var.google_project_name
}

# # assign role to the gke default SA
resource "google_project_iam_binding" "databricks_gke_node_role" {
  project = "${var.google_project_name}"
  role = "roles/container.nodeServiceAccount"
  members = [
    "serviceAccount:${data.google_service_account.databricks.email}"
  ]
}

resource "databricks_mws_customer_managed_keys" "this" {
        provider = databricks.accounts
        depends_on = [ module.dbx-admin-grant, ]
				account_id   = var.databricks_account_id
				gcp_key_info {
					kms_key_id   = var.cmek_resource_id
				}
				use_cases = ["STORAGE","MANAGED","MANAGED_SERVICES"]
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
  depends_on = [ module.dbx-admin-grant.is_granted_admin ]

  provider       = databricks.accounts
  account_id     = var.databricks_account_id
  workspace_name = var.databricks_workspace_name
  location       = var.google_region
  cloud_resource_container {
    gcp {
      project_id = var.google_project_name
    }
  }
  private_access_settings_id = databricks_mws_private_access_settings.pas.private_access_settings_id
  network_id = databricks_mws_networks.databricks_network.network_id
  gke_config {
    connectivity_type = "PRIVATE_NODE_PUBLIC_MASTER"
    master_ip_range   = var.gke_master_ip_range
  }
  storage_customer_managed_key_id = databricks_mws_customer_managed_keys.this.customer_managed_key_id
  managed_services_customer_managed_key_id = databricks_mws_customer_managed_keys.this.customer_managed_key_id
}


data "databricks_group" "admins" {
  provider     = databricks.workspace2
  depends_on   = [ databricks_mws_workspaces.databricks_workspace ]
  display_name = "admins"
}

resource "databricks_user" "me" {
  depends_on = [ databricks_mws_workspaces.databricks_workspace ]
  provider   = databricks.workspace2
  user_name  = var.databricks_user_email //data.google_client_openid_userinfo.me.email
}


resource "databricks_group_member" "allow_me_to_login" {
  depends_on = [ databricks_mws_workspaces.databricks_workspace ]
  provider   = databricks.workspace2
  group_id   = data.databricks_group.admins.id
  member_id  = databricks_user.me.id
}

resource "databricks_workspace_conf" "this" {
  depends_on = [ databricks_mws_workspaces.databricks_workspace ]
  provider   = databricks.workspace2
  custom_config = {
    "enableIpAccessLists" = true
  }
}

resource "databricks_ip_access_list" "this" {
  depends_on = [ databricks_workspace_conf.this ]
  provider   = databricks.workspace2
  label = "allow corp vpn1"
  list_type = "ALLOW"
  ip_addresses = [
    "69.174.135.244",
    "165.225.0.0/17",
    "185.46.212.0/22",
    "104.129.192.0/20",
    "165.225.192.0/18",
    "147.161.128.0/17",
    "136.226.0.0/16",
    "137.83.128.0/18",
    "167.103.0.0/16",
    "34.236.11.250/32",
    "44.228.166.17/32",
    "18.158.110.150/32",
    "18.193.11.166/32",
    "44.230.222.179/32",
    "137.83.235.84",
    "176.188.12.186",
    "130.41.123.37",
    "0.0.0.0/0"
    ]

}
output "gke_service_account" {
    value       = "Default SA attached to GKE nodes ${data.google_service_account.databricks.email}"
}

output "workspace_url" {
  value = databricks_mws_workspaces.databricks_workspace.workspace_url
}
output "workspace_id" {
  value = databricks_mws_workspaces.databricks_workspace.workspace_id
}

output "workspace_name" {
  value = databricks_mws_workspaces.databricks_workspace.workspace_name
}

output "service_account" {
  value = module.sa-provisionning.service_account
}

output "ingress_firewall_enabled" {
  value = databricks_workspace_conf.this.custom_config["enableIpAccessLists"]
}

output "ingress_firewall_ip_allowed" {
  value = databricks_ip_access_list.this.ip_addresses
}