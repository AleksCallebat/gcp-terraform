google_project = "dbx-<env>-<region>-<lob>"
google_region = "europe-west1"
databricks_account_id = "<ACCOUNT_ID>" #prod

# NAME OF THE SA THAT WILL CREATE THE WORKSPACE (SA will be provisionend and granted custom role)
workspace_creator_sa_name = "dbx-<env>-<region>-workspace-creator-sa@fe-dev-sandbox.iam.gserviceaccount.com"

## NETWORKING
# NETWORK USED BY THE DATABRICKS WORKSPACE (It is provisionned by the current terraform template)
# See https://docs.gcp.databricks.com/en/administration-guide/cloud-configurations/gcp/network-sizing.html to adjust the subnet range
google_vpc_name = "dbx-<env>-<region>-psc-vpc"
gke_master_ip_range = "10.32.0.0/28"
pod_subnet_name = "pods-subnet"
node_subnet_name = "node-subnet"
service_subnet_name = "service-subnet"
subnet_ip_cidr_range = "10.0.0.0/20"
pod_ip_cidr_range = "10.1.0.0/20"
svc_ip_cidr_range = "10.2.0.0/20"

# CMEK MANAGEMENT
cmek_resource_id = "<ENTER OUTPUT KEY>"

# PSC VARIABLES CONFIGURATION FOR PRIVATE ENDPOINT
workspace_pe_ip_name = "dbx-backend-pe-ip"
google_pe_subnet_name = "dbx-pe-subnet"
google_pe_subnet_range = "10.3.0.0/24"
workspace_pe_name = "dbx-ws-pe"
relay_pe_name = "dbx-relay-pe"
frontend_pe_ip_name = "dbx-pe-ip"

# WORKSPACE MANAGEMENT CONFIGURATION
databricks_account_console_url = "https://accounts.gcp.databricks.com"
databricks_workspace_name = "dbx-<env>-<region>-<lob>-ws"
workspace_admin_email = "<Workspace_Admin_User_EMAIL>"

# UNITY CATALOG CONFIGURATION
uc_storage_name = "dbx-<env>-<region>-<lob>-uc" # Not Read if metastore_exists=true
metastore_name = "dbx-<env>-<region>-<lob>-metastore"
use_existing_metastore = false 
workspace_users = ["user1_email","user2_email"]


