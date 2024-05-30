# # PSC endpoints creation
# # Make sure that the endpoints are created before you create the workspace
variable "relay_service_attachment" {}
variable "workspace_service_attachment" {}

variable "workspace_pe_name" {}
variable "workspace_pe_ip_name" {}
variable "frontend_pe_ip_name" {}
variable "relay_pe_ip_name" {}
variable "google_pe_subnet_name" {}
variable "google_pe_subnet_range" {}
variable "frontend_pe_name" {}
variable "relay_pe_name" {}



resource "google_compute_subnetwork" "subnet-psc-endpoint" {
  name          = "${var.google_pe_subnet_name}"
  ip_cidr_range = var.google_pe_subnet_range
  project = var.google_project
  region        = var.google_region
  network       = google_compute_network.dbx_private_vpc.id
  private_ip_google_access = true
}


resource "google_compute_address" "backend_pe_ip_address" {
  name         = "${var.relay_pe_ip_name}"
  provider     = google
  project      = var.google_project
  region       = var.google_region
  subnetwork   = google_compute_subnetwork.subnet-psc-endpoint.id
  address_type = "INTERNAL"
}

resource "google_compute_address" "frontend_pe_ip_address" {
  name         = "${var.workspace_pe_ip_name}"
  provider     = google
  project      = var.google_project
  region       = var.google_region
  subnetwork   = google_compute_subnetwork.subnet-psc-endpoint.id
  address_type = "INTERNAL"
}

resource "google_compute_forwarding_rule" "backend_psc_ep" {
  provider = google
  depends_on = [
    google_compute_address.backend_pe_ip_address
  ]
  region      = var.google_region
  project     = var.google_project
  name        = var.relay_pe_name
  network     = google_compute_network.dbx_private_vpc.id
  ip_address  = google_compute_address.backend_pe_ip_address.id
  target      = var.relay_service_attachment
  load_balancing_scheme = "" #This field must be set to "" if the target is an URI of a service attachment. Default value is EXTERNAL
}

resource "google_compute_forwarding_rule" "frontend_psc_ep" {
  provider = google
  depends_on = [
    google_compute_address.frontend_pe_ip_address
  ]
  region      = var.google_region
  name        = var.workspace_pe_name
  project     = var.google_project
  network     = google_compute_network.dbx_private_vpc.id
  ip_address  = google_compute_address.frontend_pe_ip_address.id
  target      = var.workspace_service_attachment
  load_balancing_scheme = "" #This field must be set to "" if the target is an URI of a service attachment. Default value is EXTERNAL
}
