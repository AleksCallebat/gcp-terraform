terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  alias = "google-init"
  project = var.google_project
  region  = var.google_region


}
