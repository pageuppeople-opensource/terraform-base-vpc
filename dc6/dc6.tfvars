stream_tag="Koi"
transitioning_stream_tag="Orcas"
environment_tag="LIVE"
costcenter_tag="SINGGOVDC"

vpc_name="services"
search_specific_name="candidate"
public_key_name="dc5_public"

#terraform_exec
aws_region="ap-southeast-1"
s3_bucket="terraform-dc6"
s3_key="base-vpc"

vpc_cidr="10.66.0.0/16"
#aws acccount no
aws_peer_owner_id="824362207773"
aws_parent_vpc_id="vpc-c86390ad"
aws_parent_vpc_cidr="10.46.0.0/16"
ssl_certificate_arn="arn:aws:iam::824362207773:server-certificate/star.dc6.pageuppeople.com_26-01-2018"
private_hosted_zone_name="candidate.dc6"

external_cidr_blocks="10.66.0.0/16,115.186.199.54/32"
internal_cidr_blocks="10.66.0.0/16"
nat_subnet_cidr="10.66.0.0/16"

availability_zones="ap-southeast-1a,ap-southeast-1b"
public_subnets_cidr="10.66.0.0/24,10.66.1.0/24"
private_subnets_cidr="10.66.10.0/24,10.66.11.0/24"

nat_role_tag="NETWORK"

consul_role_tag="MONITORING"
consul_iam_profile="candidate-vpc-kms-profile"
consul_security_group_name="consul"
consul_instance_type="t2.small"
consul_availability_zones="ap-southeast-1a,ap-southeast-1b"
consul_public_hosted_zone_name="consul.dc6.pageuppeople.com"
consul_amis.ap-southeast-1="ami-9cfc2fff"
instances="0"
consul_public_hosted_zone_id="Z18R8B2TADZL1Q"

vpn_cidr_range="10.12.0.0/21"
vpn_gateway_id="vgw-aabafdf8"

# change this to environment
dns_server            = "10.66.0.2"
consul_dc             = "dc6"
atlas                 = "pageup/search"
encrypted_atlas_token = "CiBaSEpt2ZGY34VWPyzY/q8vfSRox+dDy3dAFm7PRhq0/hLmAQEBAgB4WkhKbdmRmN+FVj8s2P6vL30kaMfnQ8t3QBZuz0YatP4AAAC9MIG6BgkqhkiG9w0BBwaggawwgakCAQAwgaMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMCULqV+KLKWQVI7i5AgEQgHbPi/ur7cTexZdGJGEqoFuTOLPN9AK8nJbu/yH5VuZy57n4VWSw8RpNdX7tnoEKGoeH8NKxD+FSrB+Wdvh7L/HUVMjP8Zk8uoda3eDnieobbTU4Thywn1Omm4MXipY4PJTck3uTeImpvxLfeDmAEOtqImRKVrN+"
