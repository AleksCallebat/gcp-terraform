

# # assign CMEK on Databricks side
resource "databricks_mws_customer_managed_keys" "this" {
        provider = databricks.accounts
        account_id   = var.databricks_account_id
        gcp_key_info {
            kms_key_id   = var.cmek_resource_id 
        }
        use_cases = ["STORAGE","MANAGED","MANAGED_SERVICES"]
        lifecycle {
              ignore_changes = all
        }
}