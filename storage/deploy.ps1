# Select demo folder
Set-Location storage

# Create storage account for state file
$resourceGroupName = "rg-deploy"
$storageName = "jannedeploy000020"
$containerName = "tfstate"
$stateKeyName = "demo.terraform.state"


az group create --name $resourceGroupName --location northeurope
az storage account create --resource-group $resourceGroupName --name $storageName --sku Standard_LRS
az storage container create --name "tfstate" --account-name $storageName --resource-group $resourceGroupName

$storageKey = (az storage account keys list --resource-group $resourceGroupName --account-name $storageName --query [0].value -o tsv)

# https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
$env:ARM_CLIENT_ID = "<client id>"
$env:ARM_CLIENT_SECRET = "<client secret>"
$env:ARM_TENANT_ID = "<tenant id>"
$env:ARM_SUBSCRIPTION_ID = "<subscription id>"
$env:ARM_ACCESS_KEY = $storageKey

# Init terraform
terraform init -upgrade -input=false `
    -backend-config="storage_account_name=$storageName" `
    -backend-config="container_name=$containerName" `
    -backend-config="key=$stateKeyName"

# Format & Validate
terraform fmt
terraform validate

# Plan
terraform plan -var-file="demo.tfvars" -out=tfplan

# Apply
terraform apply -auto-approve tfplan

# Wipe out resources
terraform destroy
