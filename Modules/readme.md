## Prerequisites and how to run 
1. <b>Have access to a Service Account</b> (Hereby nameded Deployer SA) with the following minimal permissions inside the project you are going to deploy it to :
- iam.roles.create
- iam.roles.delete
- iam.roles.get
- iam.roles.undelete
- iam.roles.update
- iam.serviceAccounts.actAs
- iam.serviceAccounts.create
- iam.serviceAccounts.delete
- iam.serviceAccounts.get
- iam.serviceAccounts.getAccessToken
- iam.serviceAccounts.getIamPolicy
- iam.serviceAccounts.getOpenIdToken
- iam.serviceAccounts.implicitDelegation
- iam.serviceAccounts.list
- iam.serviceAccounts.setIamPolicy
- iam.serviceAccounts.signBlob
- iam.serviceAccounts.signJwt
- resourcemanager.projects.get
- resourcemanager.projects.getIamPolicy
- resourcemanager.projects.setIamPolicy

2. <b>Authenticate to this SA</b>, for instance by having its json key and adding its path to the env variable `GOOGLE_APPLICATION_CREDENTIALS`

3. <b>Make sure that PSC is enabled </b> by the Databricks team in the region and project where you want to deploy it to

4. <b>Fill in the variables values </b> in `variables.auto.tfvars` for the three modules sa-provisionning, vpc-cmek-provisionning, and workspace-provisionning. Most value just require you to follow the naming convention. The main exception to it will be :
- Service attachment values (see comments), in workspace-provisionning, line ~36
- Unity Catalog Metastore, in workspace-provisionning. If you are the first workspace in a region, please set `use_existing_metastore=false`, otherwise fetch the correct metastore value by listing the metastores. 
- The size of the IP Ranges for the Databricks Pod, Service, and Node Subnets should be adapted for the planned usage of the workspace.

5. <b>Run</b> `Terraform init` then `Terraform apply` in the order step1->2->3. to run terraform destroy, you will need to process in the order 3->2->1, after manually erasing the storage credentials (see comment in uc.tf, line ~43)

# What these modules do

## Step 1 : sa-provisionning 
SA Deployer creates 2 SA : the Workspace Creator Service Account, and the GCP Infra Provisionner Service Account. It then grants them the required GCP & Databricks rights

## Step 2 : vpc-cmek-provisionning
SA Infra Povisionner creates the required networking, CMEK Services, as well as the required alteration to the GKE SA

## Step 3 : workspace-provisionning
SA Workspace Creator deploys the Databricks networking elements, Workspace and Unity Catalog