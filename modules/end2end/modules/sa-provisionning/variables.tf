
variable "google_project" {}
variable "google_region" {}

variable "workspace_creator_sa_name" {}

variable "workspace_creator_role_name"{}

variable "delegate_from" {
  description = "Allow either user:user.name@example.com, group:deployers@example.com or serviceAccount:sa1@project.iam.gserviceaccount.com to impersonate created service account"
  type        = list(string)
  # This is most likely going to be the email of a service Account used to run this code.
}