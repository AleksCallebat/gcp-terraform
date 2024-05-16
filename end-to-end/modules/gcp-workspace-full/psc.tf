# # PSC endpoints creation
# # Make sure that the endpoints are created before you create the workspace
variable "relay_pe_name" {}
variable "relay_service_attachment" {}
variable "relay_pe_ip_name" {}
variable "google_pe_subnet_name" {}
variable "google_pe_subnet_range" {}
variable "workspace_pe_name" {}
variable "workspace_service_attachment" {}
variable "workspace_pe_ip_name" {}


resource "google_compute_subnetwork" "subnet-psc-endpoint" {
  name          = var.google_pe_subnet_name
  ip_cidr_range = var.google_pe_subnet_range
  project = var.google_project_name
  region        = var.google_region
  network       = google_compute_network.dbx_private_vpc.id
  private_ip_google_access = true
}


resource "google_compute_address" "backend_pe_ip_address" {
  name         = var.relay_pe_ip_name
  provider     = google.deployment
  project      = var.google_shared_vpc_project
  region       = var.google_region
  subnetwork   = google_compute_subnetwork.subnet-psc-endpoint.id
  address_type = "INTERNAL"
}

resource "google_compute_address" "frontend_pe_ip_address" {
  name         = var.workspace_pe_ip_name
  provider     = google.deployment
  project      = var.google_shared_vpc_project
  region       = var.google_region
  subnetwork   = google_compute_subnetwork.subnet-psc-endpoint.id
  address_type = "INTERNAL"
}

resource "google_compute_forwarding_rule" "backend_psc_ep" {
  depends_on = [
    google_compute_address.backend_pe_ip_address
  ]
  region      = var.google_region
  project     = var.google_shared_vpc_project
  name        = var.relay_pe_name
  network     = var.google_vpc_id
  ip_address  = google_compute_address.backend_pe_ip_address.id
  target      = var.relay_service_attachment
  load_balancing_scheme = "" #This field must be set to "" if the target is an URI of a service attachment. Default value is EXTERNAL
}

resource "google_compute_forwarding_rule" "frontend_psc_ep" {
  depends_on = [
    google_compute_address.frontend_pe_ip_address
  ]
  region      = var.google_region
  name        = var.workspace_pe_name
  project     = var.google_shared_vpc_project
  network     = var.google_vpc_id
  ip_address  = google_compute_address.frontend_pe_ip_address.id
  target      = var.workspace_service_attachment
  load_balancing_scheme = "" #This field must be set to "" if the target is an URI of a service attachment. Default value is EXTERNAL
}

# Provision databricks network configuration > backend vpc endpoint
# resource "databricks_mws_vpc_endpoint" "relay_vpce" {
#   depends_on = [ google_compute_forwarding_rule.backend_psc_ep ]
#   provider = databricks.accounts
#   account_id          = var.databricks_account_id
#   vpc_endpoint_name   = "backend-relay-ep-${random_string.databricks_suffix.result}"
#   gcp_vpc_endpoint_info {
#     project_id        = var.google_shared_vpc_project
#     psc_endpoint_name = var.relay_pe_name
#     endpoint_region   = var.google_region
# }
# }

# Provision databricks network configuration > frontend vpc endpoint
# resource "databricks_mws_vpc_endpoint" "workspace_vpce" {
#   depends_on = [ google_compute_forwarding_rule.frontend_psc_ep ]
#   provider = databricks.accounts
#   account_id          = var.databricks_account_id
#   vpc_endpoint_name   = "frontend-workspace-ep-${random_string.databricks_suffix.result}"
#   gcp_vpc_endpoint_info {
#     project_id        = var.google_shared_vpc_project
#     psc_endpoint_name = var.workspace_pe
#     endpoint_region   = var.google_region
# }
# }

# Provision databricks private access configuration > applies to vpc endpoint
# resource "databricks_mws_private_access_settings" "pas" {
#   provider = databricks.accounts
#   account_id                   = var.databricks_account_id
#   private_access_settings_name = "pas-${random_string.databricks_suffix.result}"
#   region                       = var.google_region
  
#   /*
  
#   Please carefully read thru this doc before proceeding
#   https://docs.gcp.databricks.com/administration-guide/cloud-configurations/gcp/private-service-connect.html#step-6-create-a-databricks-private-access-settings-object

#   Public access enabled: Specify if public access is allowed. 
#   Choose this value carefully because it cannot be changed after the private access settings object is created.

#   If public access is enabled, users can configure the IP access lists to allow/block public access (from the public internet) 
#   to the workspaces that use this private access settings object.

#   If public access is disabled, no public traffic can access the workspaces that use this private access settings object. 
#   The IP access lists do not affect public access.

#   */

#   public_access_enabled        = false        #false
  
#   /*
#   Private access level: A specification to restrict access to only authorized Private Service Connect connections. 
#   It can be one of the below values:

#   Account: Any VPC endpoints registered with your Databricks account can access this workspace. This is the default value.
#   Endpoint: Only the VPC endpoints that you specify explicitly can access the workspace. 
#   If you choose this value, you can choose from among your registered VPC endpoints.
#   */
#   private_access_level         = "ACCOUNT"
# }

output "front_end_psc_status"{
  value = "Frontend psc status: ${google_compute_forwarding_rule.frontend_psc_ep.psc_connection_status}"
}

output "backend_end_psc_status"{
  value = "Backend psc status: ${google_compute_forwarding_rule.backend_psc_ep.psc_connection_status}"
}