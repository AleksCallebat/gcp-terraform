variable "pod_ip_cidr_range" {}
variable "service_ip_cidr_range" {}
variable "subnet_ip_cidr_range" {}
variable "gke_master_ip_range" {}
variable "google_vpc_name" {}
variable "pod_subnet_name" {}
variable "service_subnet_name" {}
variable "node_subnet_name" {}

variable "regional_metastore_ip" {}

# BUILT BASED ON THIS DOC - https://docs.gcp.databricks.com/en/security/network/classic/firewall.html#step-3-add-vpc-firewall-rules


resource "google_compute_network" "dbx_private_vpc" {
  project                 = var.google_project
  name                    = var.google_vpc_name
  auto_create_subnetworks = false
  delete_default_routes_on_create = true

}



resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = var.node_subnet_name
  ip_cidr_range = var.subnet_ip_cidr_range
  project = var.google_project
  region        = var.google_region
  network       = google_compute_network.dbx_private_vpc.id
  secondary_ip_range {
    range_name    = var.pod_subnet_name
    ip_cidr_range = var.pod_ip_cidr_range
  }
  secondary_ip_range {
    range_name    = var.service_subnet_name
    ip_cidr_range = var.service_ip_cidr_range
  }
  private_ip_google_access = true
}



module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.google_project
  network_name = google_compute_network.dbx_private_vpc.name

  rules = [
  {
    name                    = "deny-egress-${google_compute_network.dbx_private_vpc.name}"
    direction               = "EGRESS"
    priority                = 1100
    destination_ranges      = ["0.0.0.0/0"]
    source_ranges           = []
    allow = []
    deny = [{protocol="all"}]
   
  },
  {    
    name                    = "to-databricks-managed-hive-${google_compute_network.dbx_private_vpc.name}"
    direction               = "EGRESS"
    priority                = 1010
    source_ranges           = [var.regional_metastore_ip]
    allow = [{
      protocol="tcp"
      ports = ["3306"]
    }]
  }
  ]
}
# IF YOU HAVE NON-PGA DATA SOURCES, YOU WILL NEED TO MODIFY THIS.