##############################################################################
# Bastion Server
##############################################################################

resource "aws_security_group" "bastion" {
  name = "${var.bastion_security_group_name}"
  description = "Allow access from allowed_network via SSH"
  vpc_id = "${var.vpc_id}"

  # SSH
  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.external_cidr_blocks)}"]
    self = false
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]
  }

  tags = {
    Name = "bastion"
    stream = "${var.stream_tag}"
  }
}

module "bastion_servers_a" {
  source = "./bastion"

  name = "bastion_server_a"
  key_name = "${var.bastion_key_name}"
  ami = "${lookup(var.bastion_amis, var.aws_region)}"
  security_groups = "${aws_security_group.bastion.id}"
  subnet_id = "${aws_subnet.public_a.id}"
  instance_type = "${var.bastion_instance_type}"
  stream_tag = "${var.stream_tag}"
  role_tag = "${var.bastion_role_tag}"
  costcenter_tag = "${var.costcenter_tag}"
  environment_tag = "${var.environment_tag}"
}

module "bastion_servers_b" {
  source = "./bastion"

  name = "bastion_server_b"
  key_name = "${var.bastion_key_name}"
  ami = "${lookup(var.bastion_amis, var.aws_region)}"
  security_groups = "${aws_security_group.bastion.id}"
  subnet_id = "${aws_subnet.public_b.id}"
  instance_type = "${var.bastion_instance_type}"
  stream_tag = "${var.stream_tag}"
  role_tag = "${var.bastion_role_tag}"
  costcenter_tag = "${var.costcenter_tag}"
  environment_tag = "${var.environment_tag}"
}

resource "aws_route53_record" "bastion" {
   zone_id = "${var.public_hosted_zone_id}"
   name = "${var.bastion_public_hosted_zone_name}"
   type = "A"
   ttl = "300"
   records = ["${ module.bastion_servers_a.public-ips}","${ module.bastion_servers_b.public-ips}"]
}

