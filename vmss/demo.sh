# Azure CLI Virtual machine scale set commands
az vmss --help

# List public IPs
az vmss list-instance-public-ips --resource-group rg-tf-vmss --name front-vmss -o table

# List instances
az vmss list-instances --resource-group rg-tf-vmss --name front-vmss -o table

# WARNING: Delete specific instance
az vmss delete-instances --help
az vmss delete-instances --instance-ids 1 --resource-group rg-tf-vmss --name front-vmss -o table

# Scale to number of instances
az vmss scale --new-capacity 3 --resource-group rg-tf-vmss --name front-vmss -o table
