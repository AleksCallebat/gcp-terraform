

## Databricks Workspace Deployment using Terraform 

Secure Databricks workspace deployment incorporating CMEK (Customer Managed Encryption Key), PSC (Private Service Connect) and Custom VPC.

## Terminology

This Repo refers to three classes of Service Account (SA) identities in the workspace deployment flow:

+ **Deployer** - this is the SA or identity to initially authenticate to the GCP cloud environment.  The Deployer then elevates its privileges to impersonate either the *Workspace Creator* or *Infrastructure Provisioner* depending on the task being performed.
+ **Workspace Creator** - this is the privileged SA used to create a workspace and set up the Service Accounts used to run the Databricks workspace. The Workspace Creator can be removed or disabled once the workspace has been created.
+ **Infrastructure Provisioner** - this is the privileged SA used to set up Private Service Connect and Networking, CMEK (encryption) and perform GKE Service Account modification. 
  
  
+ **Target GCP Project** - this is the GCP Project in which the Databricks Workspace and associated cloud infrastructure ("Compute Plane") will be created.  

## Prerequisites  

+ Create a *Deployer* SA in the Target GCP Project with the minimum required permissions as follows:
```
iam.roles.create
iam.roles.delete
iam.roles.get
iam.roles.undelete
iam.roles.update
iam.serviceAccounts.actAs
iam.serviceAccounts.create
iam.serviceAccounts.delete
iam.serviceAccounts.get
iam.serviceAccounts.getAccessToken
iam.serviceAccounts.getIamPolicy
iam.serviceAccounts.getOpenIdToken
iam.serviceAccounts.implicitDelegation
iam.serviceAccounts.list
iam.serviceAccounts.setIamPolicy
iam.serviceAccounts.signBlob
iam.serviceAccounts.signJwt
resourcemanager.projects.get
resourcemanager.projects.getIamPolicy
resourcemanager.projects.setIamPolicy
```

This service account and privilege setup can be done by running the script

```
helpers/create_deployer_sa.sh
```

+ If configuring Private Service Connect (PSC), Confirm that PSC is enabled for the Target GCP Project and GCP region where the workspace is to be deployed to.  *This step needs to be performed by the Databricks customer account team* .


## Configure Terraform Variables

+ Configure the variable values set in the file `./end-to-end/modules/variables.auto.tfvars`.  This is referred to by the three modules `sa-provisioning`, `vpc-cmek-provisioning`, `workspace-provisioning`.
Use the comments in the variables file for configuration guidance and instruction.

## Authenticate as the Deployer SA

+ Authenticate as the Deployer SA, typically using a json key file referenced by setting the shell environment variable `GOOGLE_APPLICATION_CREDENTIALS` to point to its location.

## Create the Workspace Creator SA and Infrastructure Provisioner SA
Creates the *Workspace Creator* Service Account, and the *Infrastructure Provisioner* Service Account with the required privileges for each SA.

+ Change directory to the folder `modules/sa-provisioning`
+ Run `terraform init` (only necessary for the first Terraform execution in this folder)
+ Run `terraform apply`

## Create CMEK Services and Setup Networking
Switches to impersonate the *Infrastructure Provisioner* and then creates the required networking, CMEK Services, as well as the required alteration to the GKE SA.

+ Change directory to the folder `modules/vpc-cmek-provisioning`
+ Run `terraform init` (only necessary for the first Terraform execution in this folder)
+ Run `terraform apply`

## Deploy the Databricks Workspace
Switches to impersonate the **Workspace Creator** and then deploys the Databricks  Workspace and Unity Catalog.

+ Change directory to the folder `modules/workspace-provisioning`
+ Run `terraform init` (only necessary for the first Terraform execution in this folder)
+ Run `terraform apply`


