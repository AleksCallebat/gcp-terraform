variable "pod_ip_cidr_range" {}
variable "service_ip_cidr_range" {}
variable "subnet_ip_cidr_range" {}
variable "google_vpc_name" {}
variable "pod_subnet_name" {}
variable "service_subnet_name" {}
variable "node_subnet_name" {}



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

