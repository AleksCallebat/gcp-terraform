
variable "google_project" {
  default = "<ENTER GOOGLE PROJECT NAME>" # Enter your GCP project name
}
variable "google_region" {
  default = "<ENTER GOOGLE REGION>" # Enter your GCP region
}
variable "google_zone" {
  default = "<ENTER GOOGLE ZONE>" # Enter your GCP zone
}
variable "sa_name" {
  default = "databricks-provisioning" # Enter your service account name
}

variable "role_name"{
  default = "databricks" # Enter your role prefix

}


variable "delegate_from" {
  description = "Allow either user:user.name@example.com, group:deployers@example.com or serviceAccount:sa1@project.iam.gserviceaccount.com to impersonate created service account"
  type        = list(string)
  default     = ["<ENTER YOUR SERVICE ACCOUNT PROVISIONNING>"]
  # This is most likely going to be the email of a service Account used to run this code.
}