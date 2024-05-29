
variable "google_project" {}
variable "google_region" {}

variable "workspace_creator_sa_name" {}


variable "databricks_account_id" {}

variable "cmek_resource_id" {}

variable "google_vpc_name" {}
variable "gke_master_ip_range" {}
variable "pod_subnet_name" {}
variable "node_subnet_name" {}
variable "service_subnet_name" {}
variable "subnet_ip_cidr_range" {}
variable "pod_ip_cidr_range" {}
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