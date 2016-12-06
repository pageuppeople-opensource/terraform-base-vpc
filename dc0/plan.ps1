terraform get -update
terraform remote config `
    -backend=s3 `
    -backend-config="bucket=terraform-dc0" `
    -backend-config="key=base-vpc/tfstate/dc0/terraform.tfstate" `
    -backend-config="region=ap-southeast-2"
terraform remote pull
terraform plan ../