# Select demo folder
cd vmss

# Init terraform
terraform init

# Format & Validate
terraform fmt
terraform validate

# Plan
terraform plan -out=tfplan

# Apply
terraform apply -auto-approve tfplan

# Wipe out resources
terraform destroy
