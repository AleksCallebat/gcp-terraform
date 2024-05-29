

if [ -z "$1" ]
then
   DEPLOYER_SA=deployer-sa
else
  DEPLOYER_SA="$1"
fi

if [ -z "$2" ]
then
   DEPLOYER_SA_NAME=$DEPLOYER_SA
else
  DEPLOYER_SA_NAME="$2"
fi

PROJECT_ID=$(gcloud config get project)

gcloud iam service-accounts create ${DEPLOYER_SA} --display-name="${DEPLOYER_SA_NAME}"

echo "Adding permissions to CustomRoleDeployer role"

# Create a custom role for the Deployer
gcloud iam roles create CustomRoleDeployer \
    --project=${PROJECT_ID} \
    --file=deployer-role.json


# Assign the custom role to the service account
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${DEPLOYER_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="projects/${PROJECT_ID}/roles/CustomRoleDeployer"

#gcloud projects get-iam-policy ${PROJECT_ID}



