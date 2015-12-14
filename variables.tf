### MANDATORY ###
variable "private_hosted_zone_name" {}
variable "public_hosted_zone_id" {}
/*variable "public_hosted_zone_name" {}*/

variable "vpc_name" {
  description = "the name of the vpc"
  default = "default"
}

variable "environment" {
  description = "the name of the environment"
  default = "default"
}

variable "environment_tag" {
  description = "Role of the ec2 instance, defaults to <DEV>"
  default = "DEV"
}

variable "costcenter_tag" {
  description = "Role of the ec2 instance, defaults to <DEV>"
  default = "DEV"
}

# group our resources
variable "stream_tag" {
  default = "default"
}

###################################################################
# Vpc Peering configuration below
###################################################################

### MANDATORY ###
variable "aws_peer_owner_id"{
  description="vpc peering id"
}

### MANDATORY ###
variable "aws_parent_vpc_id"{
  description="parent vpc id"
}

### MANDATORY ###
variable "aws_parent_vpc_cidr"{
  description="parent vpc cidr"
}

###################################################################
# AWS configuration below
###################################################################
variable "bastion_key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default = "bastion"
}

variable "public_key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default = "public"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "ap-southeast-2"
}

# the ability to add additional existing security groups.
variable "additional_security_groups" {
  default = ""
}

###################################################################
# Vpc configuration below
###################################################################

### MANDATORY ###
variable "vpc_cidr"{
}

### MANDATORY ###
variable "ssl_certificate_arn" {
  description = "Required for ELB https"
}

variable "external_cidr_blocks"{
  default = "0.0.0.0/0"
}

variable "internal_cidr_blocks"{
  default = "0.0.0.0/0"
}

variable "nat_subnet_cidr"{
}

### MANDATORY ###
variable "public_subnet_cidr_a"{
}

### MANDATORY ###
variable "public_subnet_cidr_b"{
}

### MANDATORY ###
variable "private_subnet_cidr_a"{
}

### MANDATORY ###
variable "private_subnet_cidr_b"{
}

###################################################################
# NAT configuration below
###################################################################

variable "amazon_nat_ami" {
  default = {
    eu-central-1 = "ami-46073a5b"
    ap-southeast-1 = "ami-b49dace6"
    ap-southeast-2 = "ami-e7ee9edd"
    us-west-1 = "ami-7da94839"
  }
}

variable "nat_role_tag" {
  default = "NETWORK"
}

###################################################################
# Bastion configuration below
###################################################################
variable "bastion_public_hosted_zone_name" {}

variable "bastion_role_tag" {
  default = "SECURITY"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "bastion_security_group_name" {
  description = "Name of security group to use in AWS."
  default = "bastion"
}

variable "bastion_amis" {
  default = {
    eu-central-1 = "ami-46073a5b"
    ap-southeast-1 = "ami-b49dace6"
    ap-southeast-2 = "ami-e7ee9edd"
    us-west-1 = "ami-7da94839"
    eu-west-1 = "ami-69b9941e"
  }
}

# number of nodes in zone a
variable "bastion_num_nodes_subnet_a" {
  description = "Bastion server nodes in a"
  default = "1"
}

# number of nodes in zone b
variable "bastion_num_nodes_subnet_b" {
  description = "Bastion server nodes in b"
  default = "1"
}

###################################################################
# Consul configuration below
###################################################################
variable "consul_public_hosted_zone_name" {}

variable "consul_role_tag" {
  default = "MONITORING"
}

variable "consul_instance_type" {
  default = "t2.micro"
}

variable "consul_security_group_name" {
  description = "Name of security group to use in AWS."
  default = "consul"
}

variable "consul_amis" {
  default = {
    ap-southeast-2 = "ami-8997ecb3"
  }
}

variable "instances" {
  description = "Number of servers"
  default = "3"
}

# number of nodes in zone a
#DEPRECATED
variable "consul_subnet_a_num_nodes" {
  description = "Consul server nodes in a"
  default = "2"
}

# number of nodes in zone b
#DEPRECATED
variable "consul_subnet_b_num_nodes" {
  description = "Consul server nodes in b"
  default = "1"
}

variable "dns_server" {
}

variable "consul_dc" {
  default = "dev"
}

variable "atlas" {
  default = "example/atlas"
}

variable "atlas_token" {
}
