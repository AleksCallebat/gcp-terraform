



resource "databricks_mws_workspaces" "databricks_workspace" {
  provider       = databricks.accounts
  account_id     = var.databricks_account_id
  workspace_name = var.workspace_name
  
  location = var.google_region
  cloud_resource_container {
    gcp {
      project_id = var.google_project
    }
  }
  token {
    comment = "Terraform token"
  }
}



data "databricks_group" "admins" {
  depends_on   = [ databricks_mws_workspaces.databricks_workspace ]
  provider     = databricks.workspace
  display_name = "admins"
}

resource "databricks_user" "me" {
  depends_on = [ databricks_mws_workspaces.databricks_workspace ]
  provider   = databricks.workspace
  user_name  = data.google_client_openid_userinfo.me.email
}


resource "databricks_group_member" "allow_me_to_login" {
  depends_on = [ databricks_mws_workspaces.databricks_workspace ]
  provider   = databricks.workspace
  group_id   = data.databricks_group.admins.id
  member_id  = databricks_user.me.id
}

resource "databricks_workspace_conf" "this" {
  depends_on = [ databricks_mws_workspaces.databricks_workspace ]
  provider   = databricks.workspace
  custom_config = {
    "enableIpAccessLists" = true
  }
}

resource "databricks_ip_access_list" "this" {
  depends_on = [ databricks_workspace_conf.this ]
  provider   = databricks.workspace
  label = "allow corp vpn1"
  list_type = "ALLOW"
  ip_addresses = [
    "69.174.135.244",
    "165.225.0.0/17",
    "185.46.212.0/22",
    "104.129.192.0/20",
    "165.225.192.0/18",
    "147.161.128.0/17",
    "136.226.0.0/16",
    "137.83.128.0/18",
    "167.103.0.0/16",
    "34.236.11.250/32",
    "44.228.166.17/32",
    "18.158.110.150/32",
    "18.193.11.166/32",
    "44.230.222.179/32",
    "167.98.187.222",
    "137.83.235.84"
    ]

}