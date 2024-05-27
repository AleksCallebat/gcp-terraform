

module "gcp-workspace-full" {
  source = "./gcp-workspace-full" 

  google_vpc_id = var.google_vpc_name
  pod_subnet_name = var.pod_subnet_name
  gke_master_ip_range = var.gke_master_ip_range
  node_subnet_name = var.node_subnet_name
  service_subnet_name = var.service_subnet_name
  databricks_account_id = var.databricks_account_id
  google_shared_vpc_project = var.google_project
  databricks_account_console_url = var.databricks_account_console_url
  google_project_name = var.google_project
  databricks_workspace_name = "${var.databricks_workspace_name}-${var.random_string}"
  google_region = var.google_region
  workspace_admin_email = var.workspace_admin_email

  cmek_resource_id = var.cmek_resource_id
  random_string = var.random_string

  # router_name = "${var.router_name}-${local.random_string}"
  # nat_name = "${var.nat_name}-${local.random_string}"
  pod_ip_cidr_range = var.pod_ip_cidr_range
  subnet_ip_cidr_range = var.subnet_ip_cidr_range
  svc_ip_cidr_range = var.svc_ip_cidr_range
  workspace_creator_sa_name = var.workspace_creator_sa_name 
  relay_service_attachment = var.relay_service_attachment
  workspace_service_attachment = var.workspace_service_attachment
  frontend_pe_ip_name = var.frontend_pe_ip_name
  backend_pe_name = var.backend_pe_name
  frontend_pe_name = var.frontend_pe_name
  google_pe_subnet_name = var.google_pe_subnet_name
  google_pe_subnet_range = var.google_pe_subnet_range
  workspace_pe_name = var.workspace_pe_name
  workspace_pe_ip_name = var.workspace_pe_ip_name
 

  
}