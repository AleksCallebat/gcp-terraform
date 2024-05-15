cp ./variables.auto.tfvars ./sa-provisionning/variables.auto.tfvars
cd ./sa-provisionning
terraform init
terraform apply -auto-approve

echo "Provisioned the identity"

cd ..
terraform init
terraform apply -auto-approve

