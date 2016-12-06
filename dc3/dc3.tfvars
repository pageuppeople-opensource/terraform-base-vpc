stream_tag="Koi"
transitioning_stream_tag="Orcas"
environment_tag="LIVE"
costcenter_tag="UKDC"

vpc_name="services"
search_specific_name="candidate"
public_key_name="dc3_public"

#terraform_exec
aws_region="eu-west-1"
s3_bucket="terraform-dc3"
s3_key="base-vpc"

vpc_cidr="10.60.0.0/16"
aws_peer_owner_id="342212725307"
aws_parent_vpc_id="vpc-aabf98c3"
aws_parent_vpc_cidr="10.40.0.0/16"
ssl_certificate_arn="arn:aws:iam::342212725307:server-certificate/star.dc3.pageuppeople.com_31-12-2016"
private_hosted_zone_name="candidate.dc3"

external_cidr_blocks="10.60.0.0/16,115.186.199.54/32"
internal_cidr_blocks="10.60.0.0/16"
nat_subnet_cidr="10.60.0.0/16"

availability_zones="eu-west-1a,eu-west-1b,eu-west-1c"
public_subnets_cidr="10.60.0.0/24,10.60.1.0/24,10.60.2.0/24"
private_subnets_cidr="10.60.10.0/24,10.60.11.0/24,10.60.12.0/24"

nat_role_tag="NETWORK"

consul_role_tag="MONITORING"
consul_iam_profile="candidate-vpc-kms-profile"
consul_security_group_name="consul"
consul_instance_type="t2.small"
consul_public_hosted_zone_name="consul.dc3.pageuppeople.com"
consul_amis.eu-west-1="ami-c18c30b2"
instances="3"
consul_public_hosted_zone_id="ZFGHQM4P2PA2L"

vpn_cidr_range="10.12.0.0/21"
vpn_gateway_id="vgw-3a31024e"

# change this to environment
dns_server            = "10.60.0.2"
consul_dc             = "dc3"
atlas                 = "pageup/search"
encrypted_atlas_token = "CiAuUHy2cWmGnkb/LXJWxXDI0dWK1LuVXepmjj/8OpOjvhLmAQEBAgB4LlB8tnFphp5G/y1yVsVwyNHVitS7lV3qZo4//DqTo74AAAC9MIG6BgkqhkiG9w0BBwaggawwgakCAQAwgaMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMDbor6/U04pizNR+UAgEQgHbpE1SBgVVGzLoZcsD4+8Z2Y8fiJR7BTSLejZ5m/rGHCq3XSu6kSM82EVBJV9YL7AiX64EyXZf8tavx0zFzEk1TFsprBPqtipW2CpXo55JOiCeoR9HH3PGauFTLR2iyFRRcrn5e3Un7vSw7kaU24rzgN+rK5v0u"
