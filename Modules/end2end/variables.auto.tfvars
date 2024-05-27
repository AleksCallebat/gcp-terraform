google_project = "fe-dev-sandbox"
google_region = "europe-west1"
databricks_account_id = "f187f55a-9d3d-463b-aa1a-d55818b704c9" #prod

# NAME OF THE SA THAT WILL CREATE THE WORKSPACE (SA will be provisionend and granted custom role)
workspace_creator_sa_name = "alek-tf-creator-sa"
workspace_creator_role_name = "dbx_alek_tf_workspace_creator_role"

# Current identity of the deployment process (to be set in the env variable $GOOGLE_APPLICATION_CREDENTIALS)
# This is the Google Identity that will exectue the current terraform. It creates and then impersonates the workspace creator SA
# Allow either user:user.name@example.com, group:deployers@example.com or serviceAccount:deployer-sa@project.iam.gserviceaccount.com to impersonate created service account
delegate_from = ["serviceAccount:alek-deployer@fe-dev-sandbox.iam.gserviceaccount.com"] 

# DATABRICKS ADMIN EMAIL. This is the admin account from which we derive the Databricks privileges for the Workspace Creator SA.
# Workspace Creator SA will become a new Databricks Admin thanks to this grant 
dbx_existing_admin_account =  "alek-tf-priviledged-9xpb10@fe-dev-sandbox.iam.gserviceaccount.com"

## NETWORKING
# NETWORK USED BY THE DATABRICKS WORKSPACE (It is provisionned by the current terraform template)
# See https://docs.gcp.databricks.com/en/administration-guide/cloud-configurations/gcp/network-sizing.html to adjust the subnet range
google_vpc_name = "alek-tf-psc-vpc"
gke_master_ip_range = "10.32.0.0/28"
pod_subnet_name = "pods"
node_subnet_name = "node-subnet"
service_subnet_name = "service-subnet"
subnet_ip_cidr_range = "10.0.0.0/20"
pod_ip_cidr_range = "10.1.0.0/20"
svc_ip_cidr_range = "10.2.0.0/20"
# ROUTER AND NAT ARE NOT NECESSARY IF PSC IS ENABLED
# router_name = "router"
# nat_name = "nat"

# CMEK MANAGEMENT
use_existing_key = false # IF use_existing_key=false, will create a keyring with name keyring_name and a key named key_name
cmek_resource_id = "" # If use_existing_key=true, provide the id to the CMEK resource ID (shape projects/<project-name>/regions/<region-id>/,....)
keyring_name = "dbx-alek-tf-keyring"
key_name = "dbx-alek-tf-key"

# PSC VARIABLES CONFIGURATION FOR PRIVATE ENDPOINT
workspace_pe_ip_name = "dbx-backend-pe-ip"
google_pe_subnet_name = "dbx-pe-subnet"
google_pe_subnet_range = "10.3.0.0/24"
workspace_pe_name = "dbx-ws-pe"
frontend_pe_ip_name = "dbx-pe-ip"
backend_pe_name = "dbx-backend-pe"
frontend_pe_name = "dbx-frontend-pe"
# workspace_pe_ip_name = "dbx-pe-ip"

# PSC VARIABLES CONFIGURATION
# SEE DOC HERE : https://docs.gcp.databricks.com/en/resources/supported-regions.html#psc
# TO IDENTITFY THE VALUE ASSOCIATED WITH THE RGEION YOU ARE DEPLOYING TO (NEED TO BE ENABLED BY DATABRICKS BEFOREHAND)
# The Relay Attachment is used by the SCC Conection for the Backend, while the Workspace Attachement is use by both Frontend and Backend PSC
relay_service_attachment = "projects/prod-gcp-europe-west2/regions/europe-west2/serviceAttachments/plproxy-psc-endpoint-all-ports"
workspace_service_attachment = "projects/prod-gcp-europe-west1/regions/europe-west1/serviceAttachments/plproxy-psc-endpoint-all-ports"

# WORKSPACE MANAGEMENT CONFIGURATION
databricks_account_console_url = "https://accounts.gcp.databricks.com"
databricks_workspace_name = "dbx-alek-tf-ws"
workspace_admin_email = "aleksander.callebat@gmail.com"

# UNITY CATALOG CONFIGURATION
uc_storage_name = "dbx-alek-tf-uc" # Not Read if metastore_exists=true
metastore_name = "dbx-alek-tf-metastore"
use_existing_metastore = false 
workspace_users = ["aleksander.callebat+33@gmail.com","aleksander.callebat+42@gmail.com"]


