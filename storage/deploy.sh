# Select demo folder
cd storage

# Create storage account for state file
DEPLOY_STORAGE_NAME="jannedeploy000010"
DEPLOY_RG_NAME="rg-deploy"
az group create --name $DEPLOY_RG_NAME --location northeurope
az storage account create --resource-group $DEPLOY_RG_NAME --name $DEPLOY_STORAGE_NAME --sku Standard_LRS
az storage container create --name "tfstate" --account-name $DEPLOY_STORAGE_NAME --resource-group $DEPLOY_RG_NAME

ACCOUNT_KEY=$(az storage account keys list --resource-group $DEPLOY_RG_NAME --account-name $DEPLOY_STORAGE_NAME --query [0].value -o tsv)

# Init terraform
terraform init -upgrade -input=false \
    -backend-config="access_key=$ACCOUNT_KEY" \
    -backend-config="resource_group_name=$DEPLOY_RG_NAME" \
    -backend-config="storage_account_name=$DEPLOY_STORAGE_NAME" \
    -backend-config="container_name=tfstate" \
    -backend-config="key=storagedemo.terraform.state"

# Format & Validate
terraform fmt
terraform validate

# Plan
terraform plan -out=tfplan

# Apply
terraform apply -auto-approve tfplan

# Wipe out resources
terraform destroy
