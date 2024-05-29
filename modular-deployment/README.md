

# Databricks Workspace Deployment using Terraform 

Secure Databricks workspace deployment incorporating CMEK (Customer Managed Encryption Key), PSC (Private Service Connect) and Custom VPC.

This is broken out into three separate modules
1. Create the Workspace Creator SA and Infrastructure Provisioner SA
2. Create CMEK Services and Setup Networking
3. Deploy the Databricks Workspace

Each module has its own Terraform folder and configuration.

The Workspace Creation is dependent on steps 1 and 2.

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
Run the script from the Repo root, not in the `helpers` folder.   
This creates a JSON key file for the Deployer Service Account in the `./local` folder: `./local/deployer.json`
   
   
+ If configuring Private Service Connect (PSC), Confirm that PSC is enabled for the Target GCP Project and GCP region where the workspace is to be deployed to.  *This step needs to be performed by the Databricks customer account team* .


## 1. Create the Workspace Creator SA and Infrastructure Provisioner SA
This step creates the *Workspace Creator* Service Account, and the *Infrastructure Provisioner* Service Account with the required privileges for each SA.

### Option A: Configure the Terraform vars in the modular-deployment/sa-provisioning folder
+ Edit `./modular-deployment/sa-provisioning/variables.auto.tfvars` and set the values as required, according to the comments in the file.
+ These changes will need to be checked in to Git.

### Option B: set the Terraform vars locally without updating the Git Repo version
+ Make a copy of the Terraform vars file in a local folder: `cp modular-deployment/sa-provisioning/variables.auto.tfvars ./local/sa.tfvars`
+ Edit `./local/sa.tfvars` and set the values as required, according to the comments in the file.

### Change Directory to work locally in the `sa-provisioning` folder
+ Change directory to the folder `modular-deployment/sa-provisioning`

### Authenticate as the Deployer SA
+ Set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to point to the location of the key file for authenticating to the Deployer SA:  
EXAMPLE
```
export GOOGLE_APPLICATION_CREDENTIALS=../../local/deployer.json
```

### Apply the Terraform

+ Run `terraform init` (only necessary for the first Terraform execution in this folder)
+ Run `terraform apply` **OR** `terraform apply -var-file="../../local/sa.tfvars"` if a local override file has been created as per the Option listed above.



## 2. Create CMEK Services and Setup Networking
This step switches to impersonate the *Infrastructure Provisioner* and then creates the required networking, CMEK Services, as well as the required alteration to the GKE SA.

### Option A: Configure the Terraform vars in the modular-deployment/vpc-cmek-provisioning folder
+ Edit `./modular-deployment/vpc-cmek-provisioning/variables.auto.tfvars` and set the values as required, according to the comments in the file.
+ These changes will need to be checked in to Git.

### Option B: set the Terraform vars locally without updating the Git Repo version
+ Make a copy of the Terraform vars file in a local folder: `cp modular-deployment/vpc-cmek-provisioning/variables.auto.tfvars ./local/vpc-cmek.tfvars`
+ Edit `./local/vpc-cmek.tfvars` and set the values as required, according to the comments in the file.

### Change Directory to work locally in the `vpc-cmek-provisioning` folder
+ Change directory to the folder `modular-deployment/vpc-cmek-provisioning`

### Authenticate as the Deployer SA
+ Set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to point to the location of the key file for authenticating to the Deployer SA:   
EXAMPLE
```
export GOOGLE_APPLICATION_CREDENTIALS=../../local/deployer.json
```

### Apply the Terraform
+ Run `terraform init` (only necessary for the first Terraform execution in this folder)
+ Run `terraform apply` **OR** `terraform apply -var-file="../../local/vpc-cmek.tfvars"` if a local override file has been created as per the Option listed abov




## 3. Deploy the Databricks Workspace
This step switches to impersonate the **Workspace Creator** and then deploys the Databricks  Workspace and Unity Catalog.

### Option A: Configure the Terraform vars in the modular-deployment/sa-provisioning folder
+ Edit `./modular-deployment/sa-provisioning/variables.auto.tfvars` and set the values as required, according to the comments in the file.
+ These changes will need to be checked in to Git.

### Option B: set the Terraform vars locally without updating the Git Repo version
+ Make a copy of the Terraform vars file in a local folder: `cp modular-deployment/workspace-provisioning/variables.auto.tfvars ./local/workspace.tfvars`
+ Edit `./local/workspace.tfvars` and set the values as required, according to the comments in the file.

### Change Directory to work locally in the `workspace-provisioning` folder
+ Change directory to the folder `modular-deployment/workspace-provisioning`

### Authenticate as the Deployer SA
+ Set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to point to the location of the key file for authenticating to the Deployer SA:   
EXAMPLE
```
export GOOGLE_APPLICATION_CREDENTIALS=../../local/deployer.json
```

### Apply the Terraform
+ Run `terraform init` (only necessary for the first Terraform execution in this folder)
+ Run `terraform apply` **OR** `terraform apply -var-file="../../local/workspace.tfvars"` if a local override file has been created as per the Option listed abov


