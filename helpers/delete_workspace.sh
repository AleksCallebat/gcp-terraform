# REQUIREMENTS
# - FILL IN YOUR CORRECT DATABRICKS ACCOUNT ID
# - AUTHENTICATE AS YOUR CURRENT SERVICE ACCOUNT (STORED INTO A JSON CRED FILE)
# - THIS SERVICE ACCOUNT NEEDS TO HAVE IMPERSONNATION RIGHTS OVER A SERVICE ACCOUNT WHICH IS A DATABRICKS ACCOUNT ADMIN, CALLED DBX_ADMIN_SA. IF NOT, FIND ONE AND GRANT IMPERSONNATION OVER IT.
# - PUT THE DBX_ADMIN_SA EMAIL INTO THE APPROPRIATE FIELD
# - FILL IN THE CORRECT WORKSPACE ID (RUN list_workspaces if needed). IT SHOULD BE AN ~11 DIGITS ID NUMBER.

ACCOUNT_ID=$"<DATABRICKS_ACCOUNT_ID>"
CRED_FILE=$"/path/to/credentials.json"
DBX_ADMIN_SA=$"<DATABRICKS_ADMIN_SA_EMAIL>"
WORKSPACE_ID=$"<WORKSPACE_ID>"

gcloud auth login --cred-file=$CRED_FILE

TOKENID=$(gcloud auth print-identity-token --impersonate-service-account=$DBX_ADMIN_SA --include-email --audiences="https://accounts.gcp.databricks.com")
TOKENACCESS=$(gcloud auth print-access-token --impersonate-service-account=$DBX_ADMIN_SA)

curl \
  -X DELETE \
  --header "Authorization: Bearer ${TOKENID}" \
  --header "X-Databricks-GCP-SA-Access-Token: ${TOKENACCESS}" \
  https://accounts.gcp.databricks.com/api/2.0/accounts/"$ACCOUNT_ID"/workspaces/"$WORKSPACE_ID"\
  --verbose 


# If you don't have access to a service account but are an account admin, you can simply set your own email adress as the DBX_ADMIN_SA, and modify line 13 to just run gcloud auth login