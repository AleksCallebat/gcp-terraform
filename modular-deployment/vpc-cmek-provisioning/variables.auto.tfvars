google_project = "fe-dev-sandbox"
google_region = "europe-west1"

# NAME OF THE SA THAT WILL PROVISION THE GCP RESOURCES
gcp_infra_provisionning_sa = "dbx-alek-eu-gcp-infra-sa@fe-dev-sandbox.iam.gserviceaccount.com"

## NETWORKING
# NETWORK USED BY THE DATABRICKS WORKSPACE (It is provisionned by the current terraform template)
# See https://docs.gcp.databricks.com/en/administration-guide/cloud-configurations/gcp/network-sizing.html to adjust the subnet range
google_vpc_name = "aleks-psc-eu"
pod_subnet_name = "alek-pods-subnet"
node_subnet_name = "alek-node-subnet"
service_subnet_name = "alek-service-subnet"
subnet_ip_cidr_range = "10.0.0.0/20"
pod_ip_cidr_range = "10.1.0.0/20"
service_ip_cidr_range = "10.2.0.0/20"
# gke_master_ip_range = "10.32.0.0/28"

## FIREWALL IPS TO WHITELIST -- SEE DOC TO FIND REGIONAL VALUE : https://docs.gcp.databricks.com/en/resources/supported-regions.html#ip-domain-gcp
regional_metastore_ip ="34.76.244.202"

# CMEK MANAGEMENT
keyring_name = "dbx-alek-eu-keyring"
key_name = "dbx-alek-eu-keyring"
use_existing_key=true

# PSC VARIABLES CONFIGURATION FOR PRIVATE ENDPOINT
workspace_pe_ip_name = "dbx-backend-pe-ip"
google_pe_subnet_name = "dbx-pe-subnet"
google_pe_subnet_range = "10.4.0.0/24"
workspace_pe_name = "dbx-ws-pe"
relay_pe_name = "dbx-relay-pe"
relay_pe_ip_name = "dbx-relay-ip"

# PSC VARIABLES CONFIGURATION
# SEE DOC HERE : https://docs.gcp.databricks.com/en/resources/supported-regions.html#psc
# TO IDENTITFY THE VALUE ASSOCIATED WITH THE RGEION YOU ARE DEPLOYING TO (NEED TO BE ENABLED BY DATABRICKS BEFOREHAND)
# The Relay Attachment is eued by the SCC Conection for the Backend, while the Workspace Attachement is use by both Frontend and Backend PSC
workspace_service_attachment = "projects/prod-gcp-europe-west1/regions/europe-west1/serviceAttachments/plproxy-psc-endpoint-all-ports"
relay_service_attachment = "projects/prod-gcp-europe-west1/regions/europe-west1/serviceAttachments/ngrok-psc-endpoint"



