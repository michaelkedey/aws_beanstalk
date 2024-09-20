#!/bin/bash

# Run terraform fmt in the current directory
terraform fmt 

terraform init -var-file="./env/dev/.terraform.tfvars" -backend-config="./env/dev/backend.tfvars"

# Run terraform validate in the current directory
terraform validate

# plan
terraform plan -var-file="./env/dev/.terraform.tfvars"


# Run terraform fmt in all subdirectories
#find . -type d -exec sh -c 'cd "{}" && terraform fmt' \;

 # Run terraform validate in all subdirectories
#find . -type d -exec sh -c 'cd "{}" && terraform validate' \;


