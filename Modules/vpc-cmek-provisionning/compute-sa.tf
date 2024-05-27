/*
Service account attached to the GKE cluster to spin up GKE nodes
GKE node pool use this service account to call Google Cloud APIs
instead of using the default compute engine SA, databricks will use this SA
this is different than the workload identity aka SA that you'll use to connect to your data sources as explained here
https://docs.gcp.databricks.com/archive/compute/configure.html#google-service-account
*/


data "google_service_account" "databricks" {
    account_id   = "databricks" #need to use "databricks"
    # display_name = "Databricks SA for GKE nodes"
    project = var.google_project
}

# # assign role to the gke default SA
resource "google_project_iam_binding" "databricks_gke_node_role" {
  project = "${var.google_project}"
  role = "roles/container.nodeServiceAccount"
  members = [
    "serviceAccount:${data.google_service_account.databricks.email}"
  ]
}

