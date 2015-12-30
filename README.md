AWS VPC, Bastion & Consul cluster using Terraform
=============

Builds an AWS VPC, with public and private subnets.

## Requirements

* Terraform >= v0.5.1

## Installation

* install [Terraform](https://www.terraform.io/) and add it to your PATH.
* clone this repo.
* `terraform get`

## Configuration

Create a configuration file such as `~/.aws/default.tfvars` which can include mandatory and optional variables such as:

NOTE: this is currently not complete
```
bastion_key_name="<your bastion key name>"
public_key_name="<your public key name>"
private_key_name="<your private key name>"

stream_tag="<used for aws resource groups>"

aws_region="ap-southeast-2"
bastion_amis.ap-southeast-2="ami-7ff38945"

# internal hosted zone
private_hosted_zone_name="<some.internal>"
```

See `variables.tf` for more details.

Modification of the `variables.tf` file can be done like:

```
variable "bastion_amis" {
  default = {
		ap-southeast-2 = "ami-xxxxxxx"
  }
}
```

These variables can also be overriden when running terraform like so:

```
terraform (plan|apply|destroy) -var 'bastion_amis.ap-southeast-2=foozie'
```

The variables.tf terraform file can be further modified, for example it defaults to `ap-southeast-2` for the AWS region.

## Using Terraform

Execute the plan to see if everything works as expected.

```
terraform plan -var-file ~/.aws/default.tfvars -state='environment/development.tfstate'
```

If all looks good, lets build our infrastructure!

```
terraform apply -var-file ~/.aws/default.tfvars -state='environment/development.tfstate'
```

## TODO

* Finish This README
