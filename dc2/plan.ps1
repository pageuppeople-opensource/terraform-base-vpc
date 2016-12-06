terraform get
terraform remote config `
    -backend=s3 `
    -backend-config="bucket=terraform-dc2" `
    -backend-config="key=base-vpc/tfstate/dc2/terraform.tfstate" `
    -backend-config="region=ap-southeast-2"
terraform remote pull
terraform plan ../