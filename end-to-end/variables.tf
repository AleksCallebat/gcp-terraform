
variable "google_project" {}
variable "google_region" {}

variable "workspace_creator_sa_name" {}

variable "workspace_creator_role_name"{}

variable "delegate_from" {
  description = "Allow either user:user.name@example.com, group:deployers@example.com or serviceAccount:sa1@project.iam.gserviceaccount.com to impersonate created service account"
  type        = list(string)
}
variable "databricks_account_id" {}
variable "dbx_existing_admin_account" {}

variable "cmek_resource_id" {}
variable "use_existing_key" {}
variable "keyring_name" {}
variable "key_name" {}

variable "google_vpc_name" {}
variable "gke_master_ip_range" {}
variable "pod_subnet_name" {}
variable "node_subnet_name" {}
variable "service_subnet_name" {}
variable "subnet_ip_cidr_range" {}
variable "pod_ip_cidr_range" {}
# variable "nat_name" {}
# variable "router_name" {}
variable "svc_ip_cidr_range" {}

variable "relay_service_attachment" {}
variable "frontend_pe_ip_name" {}
variable "google_pe_subnet_name" {}
variable "google_pe_subnet_range" {}
variable "workspace_pe_name" {}
variable "workspace_service_attachment" {}
variable "workspace_pe_ip_name" {}
variable "backend_pe_name" {}
variable "frontend_pe_name" {}

variable "databricks_account_console_url" {}
variable "databricks_workspace_name" {}
variable "workspace_admin_email" {}

variable "uc_storage_name" {}
variable "metastore_name" {}
variable "use_existing_metastore" {}

variable "workspace_users" {}