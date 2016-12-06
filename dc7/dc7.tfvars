stream_tag="Koi"
transitioning_stream_tag="Orcas"
environment_tag="LIVE"
costcenter_tag="UNCFDC"

vpc_name="services"
search_specific_name="candidate"
public_key_name="dc7_public"

#terraform_exec
aws_region="eu-west-1"
s3_bucket="terraform-dc7"
s3_key="base-vpc"

vpc_cidr="10.67.0.0/16"
#aws acccount no
aws_peer_owner_id="356994454909"
aws_parent_vpc_id="vpc-042ce661"
aws_parent_vpc_cidr="10.47.0.0/16"
ssl_certificate_arn="arn:aws:iam::356994454909:server-certificate/star.dc7.pageuppeople.com_23-02-2018"
private_hosted_zone_name="candidate.dc7"

external_cidr_blocks="10.67.0.0/16,115.186.199.54/32"
internal_cidr_blocks="10.67.0.0/16"
nat_subnet_cidr="10.67.0.0/16"

availability_zones="eu-west-1a,eu-west-1b,eu-west-1c"
public_subnets_cidr="10.67.0.0/24,10.67.1.0/24,10.67.2.0/24"
private_subnets_cidr="10.67.10.0/24,10.67.11.0/24,10.67.12.0/24"

nat_role_tag="NETWORK"

consul_role_tag="MONITORING"
consul_iam_profile="candidate-vpc-kms-profile"
consul_security_group_name="consul"
consul_instance_type="t2.small"
consul_public_hosted_zone_name="consul.dc7.pageuppeople.com"
consul_amis.eu-west-1="ami-aa1d63d9"

instances="0"
consul_public_hosted_zone_id="Z20JMWH9WLQO8"

vpn_cidr_range="10.12.0.0/21"
vpn_gateway_id="vgw-aabafdf8"

# change this to environment
dns_server            = "10.67.0.2"
consul_dc             = "dc7"
atlas                 = "pageup/search"
encrypted_atlas_token = "CiBaSEpt2ZGY34VWPyzY/q8vfSRox+dDy3dAFm7PRhq0/hLmAQEBAgB4WkhKbdmRmN+FVj8s2P6vL30kaMfnQ8t3QBZuz0YatP4AAAC9MIG6BgkqhkiG9w0BBwaggawwgakCAQAwgaMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMCULqV+KLKWQVI7i5AgEQgHbPi/ur7cTexZdGJGEqoFuTOLPN9AK8nJbu/yH5VuZy57n4VWSw8RpNdX7tnoEKGoeH8NKxD+FSrB+Wdvh7L/HUVMjP8Zk8uoda3eDnieobbTU4Thywn1Omm4MXipY4PJTck3uTeImpvxLfeDmAEOtqImRKVrN+"
