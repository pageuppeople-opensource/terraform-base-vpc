stream_tag="Koi"
transitioning_stream_tag="Orcas"
environment_tag="DEV"
costcenter_tag="DEV"

vpc_name="services"
search_specific_name="services"
public_key_name="candidate-dc0-public"

# terraform_exec
aws_region="ap-southeast-2"
s3_bucket="terraform-dc0"
s3_key="base-vpc"

vpc_cidr="172.20.0.0/16"
aws_peer_owner_id="047651431481"
aws_parent_vpc_id="vpc-f753bd92"
aws_parent_vpc_cidr="172.16.0.0/16"
ssl_certificate_arn="arn:aws:iam::047651431481:server-certificate/dc0.pageuppeople.com_2014_10_16"
private_hosted_zone_name="candidate.dc0"

external_cidr_blocks="115.186.199.54/32,172.20.0.0/16"
internal_cidr_blocks="172.20.0.0/16"
nat_subnet_cidr="172.20.0.0/16"

availability_zones="ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
public_subnets_cidr="172.20.0.0/24,172.20.1.0/24,172.20.2.0/24"
private_subnets_cidr="172.20.10.0/24,172.20.11.0/24,172.20.12.0/24"

nat_role_tag="NETWORK"

consul_role_tag="MONITORING"
consul_iam_profile="services-vpc-kms-profile"
consul_security_group_name="consul"
consul_instance_type="t2.micro"
consul_public_hosted_zone_name="consul.dc0.pageuppeople.com"
consul_amis.ap-southeast-2="ami-ea042289"
consul_instances="2"
consul_public_hosted_zone_id="Z3CUZPEWUV1NYR"

vpn_cidr_range="10.12.0.0/21"
vpn_gateway_id="vgw-92e8da8f"

# consul configuration
dns_server            ="172.20.0.2"
consul_dc             = "dc0"
atlas                 = "pageup/search"
encrypted_atlas_token = "CiB41+vwA5IrjViQrAPdhyXrIxWHOs1OtUSH2AwuqGrfKBLlAQEBAgB4eNfr8AOSK41YkKwD3Ycl6yMVhzrNTrVEh9gMLqhq3ygAAAC8MIG5BgkqhkiG9w0BBwaggaswgagCAQAwgaIGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMWO2N2BDxeyP3O4MpAgEQgHWUXGlkBEB8wZOWfjpTDvbyY2DqBzzHQKOLj8t0GJyFwNL2jvwnZAbe8HLwf2UHkbARKxE+2PYhunpQqbqzpN+FXobgsaTzEKzbIschjepOEX+EC8WzgA8WABEGkeNS3fg5mC5iOtBNgahlAH9rP7l9dBavAAI="
