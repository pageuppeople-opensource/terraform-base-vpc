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

resource "aws_instance" "bastion" {

  instance_type = "${var.bastion_instance_type}"

  count = "${length(split(",", var.public_subnets_cidr))}"

  ami = "${lookup(var.bastion_amis, var.aws_region)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"

  associate_public_ip_address = true

  vpc_security_group_ids = ["${split(",", replace(concat(aws_security_group.bastion.id, ",", var.additional_security_groups), "/,\\s?$/", ""))}"]
  key_name = "${var.bastion_key_name}"

  tags = {
    Name = "${var.vpc_name}-${format("bastion-%02d", count.index+1)}"
    Stream = "${var.stream_tag}"
    ServerRole = "${var.bastion_role_tag}"
    "Cost Center" = "${var.costcenter_tag}"
    Environment = "${var.environment_tag}"
  }

}

resource "aws_route53_record" "bastion" {
   zone_id = "${var.bastion_public_hosted_zone_id}"
   name = "${var.bastion_public_hosted_zone_name}"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.bastion.*.public_ip}"]
}

