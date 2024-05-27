variable "pod_ip_cidr_range" {}
variable "svc_ip_cidr_range" {}
variable "subnet_ip_cidr_range" {}
# variable "router_name" {}
# variable "nat_name" {}


resource "databricks_mws_networks" "databricks_network" {
  provider   = databricks.accounts
  account_id = var.databricks_account_id

  network_name = "${var.google_vpc_id}"

  gcp_network_info {
    network_project_id    = var.google_project_name
    vpc_id                = var.google_vpc_id
    subnet_id             = var.node_subnet_name
    subnet_region         = var.google_region
    pod_ip_range_name     = var.pod_subnet_name
    service_ip_range_name = var.service_subnet_name
  }
  #  vpc_endpoints {
  #   dataplane_relay = [databricks_mws_vpc_endpoint.backend_vpce.vpc_endpoint_id]
  #   rest_api        = [databricks_mws_vpc_endpoint.workspace_vpce.vpc_endpoint_id]
  # }
}