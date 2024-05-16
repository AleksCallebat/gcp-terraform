variable "pod_ip_cidr_range" {}
variable "svc_ip_cidr_range" {}
variable "subnet_ip_cidr_range" {}
variable "router_name" {}
variable "nat_name" {}

resource "google_compute_network" "dbx_private_vpc" {
  depends_on = [ module.sa-provisionning ]
  project                 = var.google_project_name
  name                    = var.google_vpc_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = var.node_subnet_name
  ip_cidr_range = var.subnet_ip_cidr_range
  project = var.google_project_name
  region        = var.google_region
  network       = google_compute_network.dbx_private_vpc.id
  secondary_ip_range {
    range_name    = var.pod_subnet_name
    ip_cidr_range = var.pod_ip_cidr_range
  }
  secondary_ip_range {
    range_name    = var.service_subnet_name
    ip_cidr_range = var.svc_ip_cidr_range
  }
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  provider = google
  name    = var.router_name
  project = var.google_project_name
  region  = google_compute_subnetwork.network-with-private-secondary-ip-ranges.region
  network = google_compute_network.dbx_private_vpc.id
}

resource "google_compute_router_nat" "nat" {
  provider = google
  project = var.google_project_name
  name                               = var.nat_name
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "databricks_mws_networks" "databricks_network" {
  provider   = databricks.accounts
  account_id = var.databricks_account_id
  depends_on = [ module.dbx-admin-grant,module.sa-provisionning ]


  network_name = "${var.google_vpc_id}"

  gcp_network_info {
    network_project_id    = var.google_project_name
    vpc_id                = google_compute_network.dbx_private_vpc.name
    subnet_id             = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name
    subnet_region         = google_compute_subnetwork.network-with-private-secondary-ip-ranges.region
    pod_ip_range_name     = var.pod_subnet_name
    service_ip_range_name = var.service_subnet_name
  }
   vpc_endpoints {
    dataplane_relay = [databricks_mws_vpc_endpoint.relay_vpce.vpc_endpoint_id]
    rest_api        = [databricks_mws_vpc_endpoint.workspace_vpce.vpc_endpoint_id]
  }
}