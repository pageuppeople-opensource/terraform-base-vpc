AWS VPC, Bastion & Consul cluster using Terraform
=============

Builds an AWS VPC, with public and private subnets.

## Requirements

* Terraform >= v0.6.12

## Installation

* install [Terraform](https://www.terraform.io/) and add it to your PATH.
* clone this repo.
* `terraform get`

## Configuration

Create a configuration file such as `~/.aws/default.tfvars` which can include mandatory and optional variables such as:

```
aws_region="ap-southeast-2"
bastion_amis.ap-southeast-2="ami-7ff38945"

# internal hosted zone
private_hosted_zone_name="<some.internal>"
```

See `variables.tf` for more details on variables that can be used.

Variables can also be overriden when running:

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

