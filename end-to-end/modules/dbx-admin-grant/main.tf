resource "databricks_user" "sa" {
  provider = databricks.databricks_old
  display_name         = "SA for Workspace Provisionning"
  user_name = var.new_admin_account
}
resource "databricks_user_role" "my_user_account_admin" {
  provider = databricks.databricks_old
  user_id = databricks_user.sa.id
  role    = "account_admin"
}

output "granted_admin_account" {
  value       = databricks_user_role.my_user_account_admin.id
  description = "This email was added to the Databricks account as an admin user."
  
}