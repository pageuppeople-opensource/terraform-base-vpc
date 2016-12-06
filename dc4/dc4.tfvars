stream_tag="Koi"
transitioning_stream_tag="Orcas"
environment_tag="LIVE"
costcenter_tag="USVA"

vpc_name="services"
search_specific_name="candidate"
public_key_name="dc4_public"

#terraform_exec
aws_region="us-east-1"
s3_bucket="terraform-dc4"
s3_key="base-vpc"

vpc_cidr="10.63.0.0/16"
#aws acccount no
aws_peer_owner_id="342212725307"
aws_parent_vpc_id="vpc-948266f1"
aws_parent_vpc_cidr="10.43.0.0/16"
ssl_certificate_arn="arn:aws:iam::342212725307:server-certificate/star.dc4.pageuppeople.com_02-03-2018"
private_hosted_zone_name="candidate.dc4"

external_cidr_blocks="10.63.0.0/16,115.186.199.54/32"
internal_cidr_blocks="10.63.0.0/16"
nat_subnet_cidr="10.63.0.0/16"

availability_zones="us-east-1a,us-east-1b,us-east-1c"
public_subnets_cidr="10.63.0.0/24,10.63.1.0/24,10.63.2.0/24"
private_subnets_cidr="10.63.10.0/24,10.63.11.0/24,10.63.12.0/24"

nat_role_tag="NETWORK"

consul_role_tag="MONITORING"
consul_iam_profile="candidate-vpc-kms-profile"
consul_security_group_name="consul"
consul_instance_type="t2.small"
consul_public_hosted_zone_name="consul.dc4.pageuppeople.com"
consul_amis.us-east-1="ami-bb23e4d6"
instances="3"
consul_public_hosted_zone_id="Z1PMTH8TK55RDS"

vpn_cidr_range="10.12.0.0/21"
vpn_gateway_id="vgw-5723cd3e"

# change this to environment
dns_server            = "10.63.0.2"
consul_dc             = "dc4"
atlas                 = "pageup/search"
encrypted_atlas_token = "CiA+StcdYieNgLSIoLnTS+DbA7S+VWckUoEzicIUrWunqBLmAQEBAgB4PkrXHWInjYC0iKC500vg2wO0vlVnJFKBM4nCFK1rp6gAAAC9MIG6BgkqhkiG9w0BBwaggawwgakCAQAwgaMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM6n28N2LILr/4OM7oAgEQgHb2yp4aTYAfMt5ootMY6w4P5EVzZhEOC5Yccr5zJz8TrVSTPcLbwnCpELkdGvgmna4znpAaK4tbs3Hmo9LvGR46psl0p81QoqrEwYPTQqdOlH2FvWuv3ZE8MVPyOQ3EAp+gFdcwdmGStRoRRr/HwQYZbwaW/RNI"
