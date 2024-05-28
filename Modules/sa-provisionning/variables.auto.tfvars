google_project = "dbx-<env>-<region>-<lob>"
google_region = "<GOOGLE_REGION>"
databricks_account_id = "<DATABRICKS_ACCOUNT_ID>" #prod


# NAME OF THE SA THAT WILL CREATE THE WORKSPACE (SA will be provisionend and granted custom role)
workspace_creator_sa_name = "dbx-<env>-<region>-ws-creator-sa"
workspace_creator_role_name = "dbx_<env>_<region>_ws_creator_role"
gcp_infra_provisionner_name = "dbx-<env>-<region>-gcp-infra-sa"

# Current identity of the deployment process (to be set in the env variable $GOOGLE_APPLICATION_CREDENTIALS)
# This is the Google Identity that will exectue the current terraform. It creates and then impersonates the workspace creator SA
# Allow either user:user.name@example.com, group:deployers@example.com or serviceAccount:deployer-sa@project.iam.gserviceaccount.com to impersonate created service account
delegate_from = ["serviceAccount:<SA_DEPLOYER>@<GOOGLE_PROJECT>.iam.gserviceaccount.com"] 

# DATABRICKS ADMIN EMAIL. This is the admin account from which we derive the Databricks privileges for the Workspace Creator SA.
# Workspace Creator SA will become a new Databricks Admin thanks to this grant 
# THE DEPLOYER SA NEEDS TO BE THE SAME AS THE EXISTING ADMIN OR HAVE IMPERSONNATION RIGHTS OVER IT.
dbx_existing_admin_account =  "<EXISTING_DATABRICKS_ADMIN>"

# REQUIRED PERMISSIONS TO RUN APPLY AND DELETE : 
# iam.roles.create
# iam.roles.delete
# iam.roles.get
# iam.roles.undelete
# iam.roles.update
# iam.serviceAccounts.actAs
# iam.serviceAccounts.create
# iam.serviceAccounts.delete
# iam.serviceAccounts.get
# iam.serviceAccounts.getAccessToken
# iam.serviceAccounts.getIamPolicy
# iam.serviceAccounts.getOpenIdToken
# iam.serviceAccounts.implicitDelegation
# iam.serviceAccounts.list
# iam.serviceAccounts.setIamPolicy
# iam.serviceAccounts.signBlob
# iam.serviceAccounts.signJwt
# resourcemanager.projects.get
# resourcemanager.projects.getIamPolicy
# resourcemanager.projects.setIamPolicy