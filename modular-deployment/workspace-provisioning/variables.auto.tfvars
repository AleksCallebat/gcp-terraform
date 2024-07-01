google_project = "fe-dev-sandbox"
google_region = "europe-west1"
databricks_account_id = "f187f55a-9d3d-463b-aa1a-d55818b704c9" #prod
# databricks_account_id = "<ACCOUNT_ID>" #prod

# NAME OF THE SA THAT WILL CREATE THE WORKSPACE (SA will be provisionend and granted custom role)
workspace_creator_sa_name = "dbx-alek-eu-ws-creator-sa@fe-dev-sandbox.iam.gserviceaccount.com"

## NETWORKING
# NETWORK USED BY THE DATABRICKS WORKSPACE (It is provisionned by the current terraform template)
# See https://docs.gcp.databricks.com/en/administration-guide/cloud-configurations/gcp/network-sizing.html to adjust the subnet range
google_vpc_name = "aleks-psc-eu"
gke_master_ip_range = "10.32.0.0/28"
pod_subnet_name = "alek-pods-subnet"
node_subnet_name = "alek-node-subnet"
service_subnet_name = "alek-service-subnet"
# subnet_ip_cidr_range = "10.0.0.0/20"
# pod_ip_cidr_range = "10.1.0.0/20"
# svc_ip_cidr_range = "10.2.0.0/20"
private_zone_name = "databricks"
dns_name = "gcp.databricks.com."
# CMEK MANAGEMENT
cmek_resource_id = "projects/fe-dev-sandbox/locations/europe-west1/keyRings/dbx-alek-eu1-tf-keyring/cryptoKeys/tf-test"

# PSC VARIABLES CONFIGURATION FOR PRIVATE ENDPOINT
workspace_pe_ip_name = "dbx-backend-pe-ip"
google_pe_subnet_name = "dbx-pe-subnet"
# google_pe_subnet_range = "10.3.0.0/24"
workspace_pe_name = "dbx-ws-pe"
relay_pe_name = "dbx-relay-pe"
relay_pe_ip_name = "dbx-relay-ip"


# WORKSPACE MANAGEMENT CONFIGURATION
databricks_account_console_url = "https://accounts.gcp.databricks.com"
databricks_workspace_name = "dbx-alek-eu-tf-ws-psc"
workspace_admin_email = "aleksander.callebat@databricks.com"

# UNITY CATALOG CONFIGURATION
uc_storage_name = "dbx-alek-eu-tf-uc" # Not Read if metastore_exists=true
metastore_name = "aleks-cross-cloud-test"
use_existing_metastore = true 
workspace_users = []


