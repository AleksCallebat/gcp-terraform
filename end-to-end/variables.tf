
variable "google_project" {}
variable "google_region" {}

variable "priviledged_sa_name" {}

variable "role_name"{}

variable "delegate_from" {
  description = "Allow either user:user.name@example.com, group:deployers@example.com or serviceAccount:sa1@project.iam.gserviceaccount.com to impersonate created service account"
  type        = list(string)
  # This is most likely going to be the email of a service Account used to run this code.
}
variable "databricks_account_id" {}
variable "old_admin_account" {}
# variable "priviledge_sa_email" {}

variable "google_vpc_id" {}
variable "gke_master_ip_range" {}
variable "pod_subnet_name" {}
variable "node_subnet_name" {}
variable "service_subnet_name" {}
variable "cmek_resource_id" {}
variable "network_config_name" {}
variable "subnet_ip_cidr_range" {}
variable "pod_ip_cidr_range" {}
variable "nat_name" {}
variable "router_name" {}
variable "svc_ip_cidr_range" {}

variable "relay_pe_name" {}
variable "relay_service_attachment" {}
variable "relay_pe_ip_name" {}
variable "google_pe_subnet_name" {}
variable "google_pe_subnet_range" {}
variable "workspace_pe_name" {}
variable "workspace_service_attachment" {}
variable "workspace_pe_ip_name" {}

variable "databricks_account_console_url" {}
variable "databricks_workspace_name" {}
variable "databricks_user_email" {}

variable "uc_storage_name" {}
variable "metastore_name" {}
variable "metastore_exists" {}
variable "workspace_users" {}