/*
Make sure that the service account:
- Is added to databricks account console with admin role
- Has permissions listed over here 
https://docs.gcp.databricks.com/administration-guide/cloud-configurations/gcp/customer-managed-vpc.html#role-requirements
- Grant KMS Admin and Viewer role on the key
*/

google_service_account_email = "m"

/*
Service or Consumer Project, it contains Databricks managed:
Data plane (GKE)
DBFS Storage (GCS)
*/
google_project_name          = ""
/*
Host project aka Shared VPC
if not using shared vpc then use same project as google_project_name
*/
google_shared_vpc_project = ""
google_region                = "europe-west2"