resource "databricks_user" "sa" {
  provider = databricks
  
  display_name         = "SA for Account Provisionning"
  user_name = google_service_account.workspace_creator.email
}
resource "databricks_user_role" "my_user_account_admin" {
  provider = databricks
  user_id = databricks_user.sa.id
  role    = "account_admin"
}

output "granted_admin_account" {
  value       = databricks_user_role.my_user_account_admin.id
  description = "This email was added to the Databricks account as an admin user."
  
}