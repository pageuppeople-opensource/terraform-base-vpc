##############################################################################
# Bastion Server
##############################################################################

resource "aws_security_group" "bastion" {
  name = "${var.vpc_name}-bastion"
  description = "Allow access from allowed_network via SSH"
  vpc_id = "${aws_vpc.default.id}"

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
    cidr_blocks = ["${split(",", var.external_cidr_blocks)}"]
  }

  tags = {
    Name = "${var.vpc_name}-bastion"
    stream = "${var.stream_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "bastion_server_a" {
  source = "./bastion"

  name = "${var.vpc_name}-bastion-a"
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

module "bastion_server_b" {
  source = "./bastion"

  name = "${var.vpc_name}-bastion-b"
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

module "bastion_server_c" {
  source = "./bastion"

  name = "${var.vpc_name}-bastion-c"
  key_name = "${var.bastion_key_name}"
  ami = "${lookup(var.bastion_amis, var.aws_region)}"
  security_groups = "${aws_security_group.bastion.id}"
  subnet_id = "${aws_subnet.public_c.id}"
  instance_type = "${var.bastion_instance_type}"
  stream_tag = "${var.stream_tag}"
  role_tag = "${var.bastion_role_tag}"
  costcenter_tag = "${var.costcenter_tag}"
  environment_tag = "${var.environment_tag}"
}

resource "aws_route53_record" "bastion" {
   zone_id = "${var.bastion_public_hosted_zone_id}"
   name = "${var.bastion_public_hosted_zone_name}"
   type = "A"
   ttl = "300"
   records = ["${ module.bastion_server_a.public-ip }","${ module.bastion_server_b.public-ip }"]
}

