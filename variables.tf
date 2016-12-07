### MANDATORY ###
variable "private_hosted_zone_name" {}

variable "vpc_name" {
  description = "the name of the vpc"
  default = "default"
}

variable "search_specific_name"{
  description = "search teams items are going to be named after this. This is inprepartion to seperating search vs cross domain"
  default = "candidate"
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

variable "transitioning_stream_tag" {
  default = "Orcas"
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
  description = "Name of the public SSH keypair to use in AWS."
  default = "public"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "ap-southeast-2"
}

### MANDATORY ###
variable "availability_zones"{
  description="availability zones"
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
variable "public_subnets_cidr"{
  description = "Comma separated list of public subnets"
}

### MANDATORY ###
variable "private_subnets_cidr"{
  description = "Comma separated list of private subnets"
}

### MANDATORY ###
variable "vpn_cidr_range"{
  description = "cidr range from which vpn connections are allowed"
}

variable "vpn_gateway_id"{
  description = "vpn gateway id to which incoming vpn connections are to be routed"
}

###################################################################
# Consul configuration below
###################################################################
variable "consul_public_hosted_zone_id" {}
variable "consul_public_hosted_zone_name" {}

### MANDATORY ###
variable "consul_iam_profile" {
}

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
    ap-southeast-2 = "ami-fa022499",
    eu-west-1 = "ami-aa1d63d9"
  }
}

variable "consul_instances" {
  description = "Number of consul servers"
  default = "3"
}

### MANDATORY ###
variable "dns_server" {
}

variable "consul_dc" {
  default = "dev"
}

variable "atlas" {
  default = "example/atlas"
}

### MANDATORY ###
variable "encrypted_atlas_token" {
}
