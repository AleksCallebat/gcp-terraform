resource "google_service_account" "sa2" {
  provider = google.google-init
  account_id   = var.workspace_creator_sa_name
  display_name = "Service Account for Databricks Provisioning"
}


data "google_iam_policy" "this" {
  provider = google.google-init

  binding {
    role    = "roles/iam.serviceAccountTokenCreator"
    members = var.delegate_from
  }
}

resource "google_service_account_iam_policy" "impersonatable" {
  provider = google.google-init
  service_account_id = google_service_account.sa2.name
  policy_data        = data.google_iam_policy.this.policy_data
}


resource "google_project_iam_custom_role" "workspace_creator" {
  provider = google.google-init
  role_id = "${var.workspace_creator_role_name}"
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
    "compute.routers.get",
    # NOW THESE SHOULD NOT BE NEEDED
    "iam.serviceAccounts.get",
    "compute.networks.create",
    "storage.buckets.create"
    
    
  ]
}


data "google_client_config" "current" {
  provider = google.google-init

}

resource "google_project_iam_member" "sa2_can_create_workspaces" {
  role    = google_project_iam_custom_role.workspace_creator.id
  member  = "serviceAccount:${google_service_account.sa2.email}"
  project = var.google_project
  provider = google.google-init


}
# resource "google_project_iam_member" "sa2_can_usePSC" {
#   role    = "roles/compute.networkViewer"
#   member  = "serviceAccount:${google_service_account.sa2.email}"
#   project = var.google_project

# }

# IF NEED TO DEPLOY THE PSC ENDPOINT VIA THE SAME SCRIPT, UNCOMMENT THE FOLLOWING PERMISSIONS : 
resource "google_project_iam_member" "sa2_can_usePSC" {
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.sa2.email}"
  project = var.google_project
  provider = google.google-init

}

resource "google_project_iam_member" "sa2_is_compute_admin" {
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.sa2.email}"
  project = var.google_project
  provider = google.google-init

}

resource "google_project_iam_member" "sa2_is_owner" {
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.sa2.email}"
  project = var.google_project
  provider = google.google-init

}

# NEEDED TO PROVISION MANUALLY THE GKE SA
resource "google_project_iam_member" "sa2_is_sa_admin" {
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.sa2.email}"
  project = var.google_project
  provider = google.google-init

}

# NEEDED TO CREATE / MANAGE THE CMEK
resource "google_project_iam_member" "sa2_is_kms_admin" {
  role    = "roles/cloudkms.admin"
  member  = "serviceAccount:${google_service_account.sa2.email}"
  project = var.google_project
  provider = google.google-init

}