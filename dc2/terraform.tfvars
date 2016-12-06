stream_tag="Koi"
transitioning_stream_tag="Orcas"
environment_tag="LIVE"
costcenter_tag="AUDC"

vpc_name="services"
search_specific_name="candidate"
public_key_name="dc2_public"

#terraform_exec
aws_region="ap-southeast-2"
s3_bucket="terraform-dc2"
s3_key="base-vpc"

vpc_cidr="10.61.0.0/16"
aws_peer_owner_id="342212725307"
aws_parent_vpc_id="vpc-5ef21f37"
aws_parent_vpc_cidr="10.41.0.0/16"
ssl_certificate_arn="arn:aws:iam::342212725307:server-certificate/dc2.pageuppeople.com_2017"
private_hosted_zone_name="candidate.dc2"

external_cidr_blocks="10.61.0.0/16,115.186.199.54/32"
internal_cidr_blocks="10.61.0.0/16"
nat_subnet_cidr="10.61.0.0/16"

availability_zones="ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
public_subnets_cidr="10.61.0.0/24,10.61.1.0/24,10.61.2.0/24"
private_subnets_cidr="10.61.10.0/24,10.61.11.0/24,10.61.12.0/24"

nat_role_tag="NETWORK"

consul_role_tag="MONITORING"
consul_iam_profile="candidate-vpc-kms-profile"
consul_security_group_name="consul"
consul_instance_type="t2.small"
consul_public_hosted_zone_name="consul.dc2.pageuppeople.com"
consul_amis.ap-southeast-2="ami-fa022499"
instances="3"
consul_public_hosted_zone_id="Z1YDPWQBDU0V3U"

vpn_cidr_range="10.12.0.0/21"
vpn_gateway_id="vgw-89e8da94"

# change this to environment
dns_server            = "10.61.0.2"
consul_dc             = "dc2"
atlas                 = "pageup/search"
encrypted_atlas_token = "CiA3bsUGbRW6siXg9B/g0Q9G6LAF9ycmNgtgmzbzdUH7/RLmAQEBAgB4N27FBm0VurIl4PQf4NEPRuiwBfcnJjYLYJs283VB+/0AAAC9MIG6BgkqhkiG9w0BBwaggawwgakCAQAwgaMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMWckUItk9skUAnZJGAgEQgHaxxHU4IVuTCqMOytzALFzNqA3VyfmdmZUagwx/eElSIWxkaBuWe3X/lxi2N35uNJZlVkK4dlcWy4xrLETQv5CUZuUhQjg6YtJT5cnEkP/3gECR8YvSE9ZktTTKb2sFKRp3jeb2neHS//TUrteR2Ge1jF2tkkWt"
