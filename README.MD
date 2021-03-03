# TerraformModuleApplyingDSC

Run terraform init in the pre-create-resources folder to create the Key Vault and Storage Account for remote state.
add secrets to key vault

Note: provider.tf uses remote state and has the pre-create-resources hard-coded because terraform does not support variables in the provider.tf backend configuration section.

run terraform init to setup remote state
run terraform plan
run terraform apply