
variable "google_project" {
  default = "fe-dev-sandbox" # Enter your GCP project name
}
variable "google_region" {
  default = "europe-west1" # Enter your GCP region
}
variable "google_zone" {
  default = "euroe-west1-a" # Enter your GCP zone
}
variable "prefix" {
  default = "alek-workspace-sa" # Enter your service account name
}

variable "role_name"{
  default = "alek_deployer_sa_role_2" # Enter your role prefix

}


variable "delegate_from" {
  description = "Allow either user:user.name@example.com, group:deployers@example.com or serviceAccount:sa1@project.iam.gserviceaccount.com to impersonate created service account"
  type        = list(string)
  default     = ["serviceAccount:alek-deployer@fe-dev-sandbox.iam.gserviceaccount.com"]
  # This is most likely going to be the email of a service Account used to run this code.
}