# # PSC endpoints creation
# # Make sure that the endpoints are created before you create the workspace

variable "workspace_pe_name" {}
variable "workspace_pe_ip_name" {}
variable "google_pe_subnet_name" {}
variable "google_pe_subnet_range" {}
variable "relay_pe_name" {}

# Provision databricks network configuration > backend vpc endpoint
resource "databricks_mws_vpc_endpoint" "relay_vpce" {
  provider = databricks.accounts
  account_id          = var.databricks_account_id
  vpc_endpoint_name   = "backend-relay-ep"
  gcp_vpc_endpoint_info {
    project_id        = var.google_shared_vpc_project
    psc_endpoint_name = var.relay_pe_name
    endpoint_region   = var.google_region
}
}

# # Provision databricks network configuration > frontend vpc endpoint
resource "databricks_mws_vpc_endpoint" "workspace_vpce" {
  provider = databricks.accounts
  account_id          = var.databricks_account_id
  vpc_endpoint_name   = "rest-workspace-ep"
  gcp_vpc_endpoint_info {
    project_id        = var.google_shared_vpc_project
    psc_endpoint_name = var.workspace_pe_name
    endpoint_region   = var.google_region
}
}

# Provision databricks private access configuration > applies to vpc endpoint
resource "databricks_mws_private_access_settings" "pas" {
  provider = databricks.accounts
  private_access_settings_name = "pas-settings"
  region                       = var.google_region
  
  /*
  
  Please carefully read thru this doc before proceeding
  https://docs.gcp.databricks.com/administration-guide/cloud-configurations/gcp/private-service-connect.html#step-6-create-a-databricks-private-access-settings-object

  Public access enabled: Specify if public access is allowed. 
  Choose this value carefully because it cannot be changed after the private access settings object is created.

  If public access is enabled, users can configure the IP access lists to allow/block public access (from the public internet) 
  to the workspaces that use this private access settings object.

  If public access is disabled, no public traffic can access the workspaces that use this private access settings object. 
  The IP access lists do not affect public access.

  */

  public_access_enabled        = true        #false
  
  /*
  Private access level: A specification to restrict access to only authorized Private Service Connect connections. 
  It can be one of the below values:

  Account: Any VPC endpoints registered with your Databricks account can access this workspace. This is the default value.
  Endpoint: Only the VPC endpoints that you specify explicitly can access the workspace. 
  If you choose this value, you can choose from among your registered VPC endpoints.
  */
  private_access_level         = "ACCOUNT"
}