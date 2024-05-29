resource "google_service_account" "workspace_creator" {
  provider = google
  account_id   = var.workspace_creator_sa_name
  display_name = "Service Account for Databricks Provisioning"
}

resource "google_service_account" "gcp_infra_provisioner_name" {
  provider = google
  account_id   = var.gcp_infra_provisioner_name
  display_name = "Service Account Provisionning PSC & CMEK inside Google"
}

data "google_iam_policy" "this" {
  provider = google
  binding {
    role    = "roles/iam.serviceAccountTokenCreator"
    members = var.delegate_from
  }
}

resource "google_service_account_iam_policy" "impersonate_workspace_creator" {
  provider = google
  service_account_id = google_service_account.workspace_creator.name
  policy_data        = data.google_iam_policy.this.policy_data
}
resource "google_service_account_iam_policy" "impersonate_gcp_infra_provisionner" {
  provider = google
  service_account_id = google_service_account.gcp_infra_provisioner_name.name
  policy_data        = data.google_iam_policy.this.policy_data
}

resource "google_project_iam_custom_role" "workspace_creator" {
  provider = google
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
    "cloudkms.cryptoKeys.getIamPolicy",
    "cloudkms.cryptoKeys.setIamPolicy",
    # THESE ARE NEEDED TO PROVISION A UC METASTORE
    "storage.buckets.create",
    "storage.buckets.get",
    "storage.buckets.delete"
    
    
  ]
}

data "google_client_config" "current" {}

resource "google_project_iam_member" "workspace_creator_can_create_workspaces" {
  role    = google_project_iam_custom_role.workspace_creator.id
  member  = "serviceAccount:${google_service_account.workspace_creator.email}"
  project = var.google_project
  provider = google
}

resource "google_project_iam_member" "workspace_creator_can_usePSC" {
  role    = "roles/compute.networkViewer"
  member  = "serviceAccount:${google_service_account.workspace_creator.email}"
  project = var.google_project

}

# GCP RESOURCES PERMISSIONS
resource "google_project_iam_member" "workspace_creator_can_createPSC" {
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.gcp_infra_provisioner_name.email}"
  project = var.google_project
}

resource "google_project_iam_member" "workspace_creator_is_compute_admin" {
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.gcp_infra_provisioner_name.email}"
  project = var.google_project

}


# NEEDED TO AVOID USING THE DEFAULT COMPUTE ENGINE SA
resource "google_project_iam_member" "gcp_infra_provisionner_can_assign_role" {
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.gcp_infra_provisioner_name.email}"
  project = var.google_project
}


# NEEDED TO PROVISION MANUALLY THE GKE SA
resource "google_project_iam_member" "gcp_infra_provisionner_is_sa_admin" {
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.gcp_infra_provisioner_name.email}"
  project = var.google_project
}

# NEEDED TO CREATE / MANAGE THE CMEK
resource "google_project_iam_member" "gcp_infra_provisionner_is_kms_admin" {
  role    = "roles/cloudkms.admin"
  member  = "serviceAccount:${google_service_account.gcp_infra_provisioner_name.email}"
  project = var.google_project
}

resource "google_project_iam_member" "workspace_creator_can_read_kms" {
  role    = "roles/cloudkms.viewer"
  member  = "serviceAccount:${google_service_account.workspace_creator.email}"
  project = var.google_project
}