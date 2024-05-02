resource "google_service_account" "sa2" {
  account_id   = "${var.prefix}-sa2"
  display_name = "Service Account for Databricks Provisioning"
}

output "service_account" {
  value       = google_service_account.sa2.email
  description = "Add this email as a user in the Databricks account console"
}

data "google_iam_policy" "this" {
  binding {
    role    = "roles/iam.serviceAccountTokenCreator"
    members = var.delegate_from
  }
}

resource "google_service_account_iam_policy" "impersonatable" {
  service_account_id = google_service_account.sa2.name
  policy_data        = data.google_iam_policy.this.policy_data
}


resource "google_project_iam_custom_role" "workspace_creator" {
  role_id = "${var.role_name}"
  title   = "Databricks Workspace Creator "
  project = var.google_project
  permissions = [
     "iam.serviceAccounts.getIamPolicy",
     "iam.serviceAccounts.getOpenIdToken",
    "iam.serviceAccounts.setIamPolicy",
    "iam.roles.create",
    "iam.roles.delete",
    "iam.roles.get",
    "iam.roles.update",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.projects.setIamPolicy",
    "serviceusage.services.get",
    "serviceusage.services.list",
    "serviceusage.services.enable",
    "compute.networks.get",
    "compute.projects.get",
    "compute.subnetworks.get",

  ]
}


data "google_client_config" "current" {}

resource "google_project_iam_member" "sa2_can_create_workspaces" {
  role    = google_project_iam_custom_role.workspace_creator.id
  member  = "serviceAccount:${google_service_account.sa2.email}"
  project = var.google_project

}
resource "google_project_iam_member" "sa2_can_usePSC" {
  role    = "roles/compute.networkViewer"
  member  = "serviceAccount:${google_service_account.sa2.email}"
  project = var.google_project

}

# IF NEED TO DEPLOY THE PSC ENDPOINT VIA THE SAME SCRIPT, UNCOMMENT THE FOLLOWING PERMISSIONS : 
# resource "google_project_iam_member" "sa2_can_usePSC" {
#   role    = "roles/compute.networkAdmin"
#   member  = "serviceAccount:${google_service_account.sa2.email}"
#   project = var.google_project

# }

# resource "google_project_iam_member" "sa2_can_usePSC" {
#   role    = "roles/owner"
#   member  = "serviceAccount:${google_service_account.sa2.email}"
#   project = var.google_project
# s
# }