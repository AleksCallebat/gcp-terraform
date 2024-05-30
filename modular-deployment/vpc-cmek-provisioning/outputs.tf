output "cmek_resource_id" {
  value = var.use_existing_key?"not provisioned as use_existing_key=false":google_kms_crypto_key.databricks_key[0].id
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

output "backend_psc_ep" {
  value = google_compute_forwarding_rule.backend_psc_ep.id
}

output "frontend_psc_ep" {
  value = google_compute_forwarding_rule.frontend_psc_ep.id
}