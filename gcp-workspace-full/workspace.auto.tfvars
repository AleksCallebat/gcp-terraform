# databricks_account_id     = "9fcbb245-7c44-4522-9870-e38324104cf8" #staging
# databricks_account_console_url = "https://accounts.staging.gcp.databricks.com"

databricks_account_id = "f187f55a-9d3d-463b-aa1a-d55818b704c9" #prod
databricks_account_console_url = "https://accounts.gcp.databricks.com" #prod

databricks_workspace_name = "aleksander-tf-test"
databricks_admin_user = "aleksander.callebat@databricks.com" 

google_vpc_id = "aleksander-tf-test-vpc"
gke_node_subnet = "node-subnet"
gke_pod_subnet = "pod-subnet"
gke_service_subnet = "service-subnet"
gke_master_ip_range = "10.32.0.0/28" # fixed size of /28

/*
Databricks PSC endpoints name
workspace_pe = user to webapp/api's and dataplane to api's
relay_pe = dataplane to relay service
*/
workspace_pe = "aleksander-tf-test-c1-frontend-ep" 
relay_pe = "aleksander-tf-test-c1-backend-ep" 

# primary subnet providing ip addresses to PSC endpoints
google_pe_subnet = "aleksander-tf-test-psc-endpoint-subnet"

# Private ip address assigned to PSC endpoints
relay_pe_ip_name = "aleksander-tf-test-backend-pe-ip"
workspace_pe_ip_name = "aleksander-tf-test-frontend-pe-ip"

/*
Databricks PSC service attachments
https://docs.gcp.databricks.com/resources/supported-regions.html#psc
*/
relay_service_attachment = "projects/prod-gcp-us-central1/regions/us-central1/serviceAttachments/ngrok-psc-endpoint"
workspace_service_attachment = "projects/prod-gcp-us-central1/regions/us-central1/serviceAttachments/plproxy-psc-endpoint-all-ports"

# DNS Configs
private_zone_name  = "databricks"
dns_name = "gcp.databricks.com." #trailing dot(.) is required


# Only required if you are using CMEK
cmek_resource_id = "projects/fe-dev-sandbox/locations/westeurope1/keyRings/alek-test/cryptoKeys/alek-key"
