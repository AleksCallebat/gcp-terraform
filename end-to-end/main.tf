resource "random_string" "suffix" {
  special = false
  upper   = false
  length  = 6
}

locals {
  random_string = random_string.suffix.result
}

module "gcp-workspace-full" {
  source = "./modules/gcp-workspace-full" 

  google_vpc_id = "${var.google_vpc_id}-${local.random_string}"
  pod_subnet_name = "${var.pod_subnet_name}-${local.random_string}"
  gke_master_ip_range = var.gke_master_ip_range
  node_subnet_name = "${var.node_subnet_name}-${local.random_string}"
  service_subnet_name = "${var.service_subnet_name}-${local.random_string}"
  cmek_resource_id = var.cmek_resource_id
  network_config_name = "${var.network_config_name}-${local.random_string}"
  databricks_account_id = var.databricks_account_id 
  google_shared_vpc_project = var.google_project
  databricks_account_console_url = var.databricks_account_console_url
  google_project_name = var.google_project 
  databricks_workspace_name = "${var.databricks_workspace_name}-${local.random_string}"
  google_region = var.google_region
  databricks_user_email = var.databricks_user_email
 
  router_name = "${var.router_name}-${local.random_string}"
  nat_name = "${var.nat_name}-${local.random_string}"
  pod_ip_cidr_range = var.pod_ip_cidr_range
  subnet_ip_cidr_range = var.subnet_ip_cidr_range
  svc_ip_cidr_range = var.svc_ip_cidr_range
  workspace_creator_sa_name = var.workspace_creator_sa_name 
  random_string = random_string.suffix.result 
  relay_service_attachment = var.relay_service_attachment
  workspace_service_attachment = var.workspace_service_attachment
  google_pe_subnet_name = var.google_pe_subnet_name
  google_pe_subnet_range = var.google_pe_subnet_range
  workspace_pe_name = var.workspace_pe_name
  frontend_pe_ip_name = var.frontend_pe_ip_name
  backend_pe_name = var.backend_pe_name
  frontend_pe_name = var.frontend_pe_name
  workspace_pe_ip_name = var.workspace_pe_ip_name
 
  delegate_from = var.delegate_from
  workspace_creator_role_name = var.workspace_creator_role_name
  existing_dbx_admin_account = var.existing_dbx_admin_account

  
}