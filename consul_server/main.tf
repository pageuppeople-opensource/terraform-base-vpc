variable "name" {}
variable "environment" {}
variable "role_tag" {}
variable "environment_tag" {}
variable "costcenter_tag" {}
variable "stream_tag" {}
variable "ami" {}
variable "instance_type" {}
variable "region" {}
variable "subnet_id" {}
variable "security_groups" {}
variable "key_name" {}
variable "num_nodes" {}
variable "total_nodes" {}
variable "dns_server" {}
variable "consul_dc" {}
variable "atlas" {}
variable "atlas_token" {}

resource "template_file" "user_data" {
  filename = "${path.module}/templates/user-data.tpl"

  vars {
    dns_server  = "${var.dns_server}"
    num_nodes   = "${var.total_nodes}"
    consul_dc   = "${var.consul_dc}"
    atlas       = "${var.atlas}"
    atlas_token = "${var.atlas_token}"
  }
}

resource "aws_instance" "consul" {

  instance_type = "${var.instance_type}"

  ami = "${var.ami}"
  subnet_id = "${var.subnet_id}"

  # This may be temporary
  associate_public_ip_address = "false"
  user_data = "${template_file.user_data.rendered}"

  # Our Security groups
  security_groups = ["${split(",", replace(var.security_groups, "/,\s?$/", ""))}"]
  key_name = "${var.key_name}"

  # consul nodes in subnet
  count = "${var.num_nodes}"

  tags {
    Name = "${var.name}-${count.index+1}"
    Stream = "${var.stream_tag}"
    consul = "server-${var.environment}"
    # required for ops reporting
    ServerRole = "${var.role_tag}"
    "Cost Center" = "${var.costcenter_tag}"
    Environment = "${var.environment_tag}"
  }

}
