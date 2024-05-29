output "cmek_resource_id" {
  value = google_kms_crypto_key.databricks_key.id
}

output "vpc_id" {
    value = google_compute_network.dbx_private_vpc.id
}


output "compute-sa" {
    value = data.google_service_account.databricks.email
  
}

output "node_subnet_name" {
  value = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name
}

output "pod_subnet_name" {
  value = var.pod_subnet_name
}

output "service_subnet_name" {
  value = var.service_subnet_name
}

