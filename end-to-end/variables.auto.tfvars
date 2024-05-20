google_project = "dbrickspoc"
google_region = "europe-west1"

#NAME OF THE SA THAT WILL BE CREATED FOR WORKSPACE CRETATION
workspace_creator_sa_name = "priviledged-sa-2"
workspace_creator_role_name = "dbx_deployer_priviledged"

#current identity (set in $GOOGLE_APPLICATION_CREDENTIALS)
delegate_from = ["serviceAccount:dbx-workspacecreator@dbrickspoc.iam.gserviceaccount.com"] 
databricks_account_id = "4fcc3cd4-3c85-4e92-bac3-442bd477c573" #prod

# DATABRICKS ADMIN EMAIL. This is the admin account from which we derive the Databricks priviledges for the Workspace Creator SA.
# Workspace Creator SA will become a new Databricks Admin thanks to this grant (see module dbx-admin-grant)
existing_dbx_admin_account =  "databricks-workspace-priv-sa@dbrickspoc.iam.gserviceaccount.com"

#NETWORKING
google_vpc_id = "db-mq-ln-psc-vpc"
gke_master_ip_range = "10.32.0.0/28"
pod_subnet_name = "pods"
node_subnet_name = "node-subnet"
service_subnet_name = "service-subnet"
router_name = "router"
nat_name = "nat"
subnet_ip_cidr_range = "10.0.0.0/20"
pod_ip_cidr_range = "10.1.0.0/20"
svc_ip_cidr_range = "10.2.0.0/20"
cmek_resource_id = "projects/dbrickspoc/locations/europe-west1/keyRings/dbx-mq-ln-keyring/cryptoKeys/dbx-mq-ln-key"
network_config_name = "dbx-network-config" #DATABRICKS SIDE CONFIGURATION OBJECT NAME

##PSC VARIABLES CONFIGURATION FOR PRIVATE ENDPOINT
backend_pe_ip_name = "dbx-backend-pe-ip"
google_pe_subnet_name = "dbx-pe-subnet"
google_pe_subnet_range = "10.3.0.0/24"
workspace_pe_name = "dbx-ws-pe"
frontend_pe_ip_name = "dbx-pe-ip"
backend_pe_name = "dbx-backend-pe"
frontend_pe_name = "dbx-frontend-pe"
workspace_pe_ip_name = "dbx-pe-ip"

#DATABRICKS VARIABLE LINKED TO THE ACTIVATED PSC ATTACHMENT
relay_service_attachment = "projects/prod-gcp-europe-west2/regions/europe-west2/serviceAttachments/plproxy-psc-endpoint-all-ports"
workspace_service_attachment = "projects/prod-gcp-europe-west1/regions/europe-west1/serviceAttachments/plproxy-psc-endpoint-all-ports"

#WORKSPACE MANAGEMENT
databricks_account_console_url = "https://accounts.gcp.databricks.com"
databricks_workspace_name = "db-mq-ln-psc-ws"
databricks_user_email = "aleksander.callebat@gmail.com"

#CONFIGURE UC
uc_storage_name = "dbx-uc-storage"
metastore_name = "metastore-eu-west1"
metastore_exists = true
workspace_users = ["aleksander.callebat+42@gmail.com"]