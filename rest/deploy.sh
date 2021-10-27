# Select demo folder
cd rest

# Init terraform
terraform init

# Format & Validate
terraform fmt
terraform validate

# Plan with example bearer token
terraform plan --var bearer_token=Sup3rSecret1Token! -out=tfplan

# Apply
terraform apply -auto-approve tfplan

# Wipe out resources
terraform destroy
