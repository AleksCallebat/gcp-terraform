google_project = "fe-dev-sandbox"
google_region = "europe-west2"

priviledged_sa_name = "alek-tf-priviledged"
# priviledge_sa_email = "alek-tf-priviledged@fe-dev-sandbox.iam.gserviceaccount.com"


role_name = "dbx_deployer_priviledged"
delegate_from = ["serviceAccount:alek-deployer@fe-dev-sandbox.iam.gserviceaccount.com"]

databricks_account_id = "f187f55a-9d3d-463b-aa1a-d55818b704c9"
old_admin_account =  "alek-tf@fe-dev-sandbox.iam.gserviceaccount.com"


google_vpc_id = "alek-tf-vpc"
gke_master_ip_range = "10.32.0.0/28"
pod_subnet_name = "pods"
pod_ip_cidr_range = "10.1.0.0/20"
node_subnet_name = "alek-tf-subnet"
subnet_ip_cidr_range = "10.0.0.0/20"
service_subnet_name = "svc"
svc_ip_cidr_range = "10.2.0.0/20"
router_name = "router"
nat_name = "nat"
cmek_resource_id = "projects/fe-dev-sandbox/locations/europe-west2/keyRings/alek-keyring/cryptoKeys/alek-key"
network_config_name = "alek-tf-net-config" #DATABRICKS SIDE CONFIGURATION OBJECT NAME

databricks_account_console_url = "https://accounts.gcp.databricks.com"
databricks_workspace_name = "alek-tf-ws"
databricks_user_email = "aleksander.callebat@gmail.com"