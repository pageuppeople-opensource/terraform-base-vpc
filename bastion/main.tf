variable "name" {}
variable "stream_tag" {}
variable "role_tag" {}
variable "environment_tag" {}
variable "costcenter_tag" {}
variable "ami" {}
variable "key_name" {}
variable "security_groups" {}
variable "subnet_id" {}
variable "instance_type" {}

resource "aws_instance" "bastion" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = ["${split(",", replace(var.security_groups, "/,\s?$/", ""))}"]

  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  source_dest_check = false
  tags = {
    Name = "${var.name}"
    Stream = "${var.stream_tag}"
    ServerRole = "${var.role_tag}"
    "Cost Center" = "${var.costcenter_tag}"
    Environment = "${var.environment_tag}"
  }
}
