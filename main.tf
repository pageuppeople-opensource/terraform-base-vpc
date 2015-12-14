provider "aws" {
  region = "${var.aws_region}"
}

##############################################################################
# VPC configuration
##############################################################################
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${var.vpc_name} VPC"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.vpc_name} internet gateway"
  }
}

resource "aws_vpc_dhcp_options" "default" {
  domain_name = "${var.aws_region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "${var.vpc_name}"
  }
}

resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id = "${aws_vpc.default.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.default.id}"
}

##############################################################################
# VPC Peering
##############################################################################

resource "aws_vpc_peering_connection" "vpc_to_parent" {
  peer_owner_id = "${var.aws_peer_owner_id}"
  peer_vpc_id = "${var.aws_parent_vpc_id}"
  vpc_id = "${aws_vpc.default.id}"
  auto_accept = true

  tags {
    Name = "${var.vpc_name} to parent peering"
    stream = "${var.stream_tag}"
  }
}

##############################################################################
# Public Subnets
##############################################################################
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "public route table"
    Stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${concat(var.aws_region, "a")}"
  cidr_block = "${var.public_subnet_cidr_a}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc_name}PublicA"
    stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${concat(var.aws_region, "b")}"
  cidr_block = "${var.public_subnet_cidr_b}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc_name}PublicB"
    stream = "${var.stream_tag}"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public_b" {
  subnet_id = "${aws_subnet.public_b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

##############################################################################
# NAT Boxes
##############################################################################

resource "aws_security_group" "nat" {
  #name = "${var.vpc_name} nat" forces new resource
  name = "NAT"
  description = "NAT security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.nat_subnet_cidr)}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.vpc_name} NAT security group"
    stream = "${var.stream_tag}"
  }
}

# module plz
resource "aws_instance" "nat_a" {

  # configurable plz
  instance_type = "t2.micro"

  ami = "${lookup(var.amazon_nat_ami, var.aws_region)}"

  subnet_id = "${aws_subnet.public_a.id}"
  associate_public_ip_address = "true"
  security_groups = ["${aws_security_group.nat.id}"]
  key_name = "${var.public_key_name}"
  count = "1"

  source_dest_check = false

  tags {
    Name = "NAT_${var.vpc_name}-a"
    stream = "${var.stream_tag}"
    role_tag = "${var.nat_role_tag}"
    costcenter_tag = "${var.costcenter_tag}"
    environment_tag = "${var.environment_tag}"
  }
}

# module plz
resource "aws_instance" "nat_b" {

  # configurable plz
  instance_type = "t2.micro"

  ami = "${lookup(var.amazon_nat_ami, var.aws_region)}"

  subnet_id = "${aws_subnet.public_a.id}"
  associate_public_ip_address = "true"
  security_groups = ["${aws_security_group.nat.id}"]
  key_name = "${var.public_key_name}"
  count = "1"

  source_dest_check = false

  tags {
    Name = "NAT_${var.vpc_name}-b"
    stream = "${var.stream_tag}"
    role_tag = "${var.nat_role_tag}"
    costcenter_tag = "${var.costcenter_tag}"
    environment_tag = "${var.environment_tag}"
  }
}

##############################################################################
# Private subnets
##############################################################################

resource "aws_route_table" "private_a" {
  vpc_id = "${aws_vpc.default.id}"

  route {
      vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_to_parent.id}"
      cidr_block = "${var.aws_parent_vpc_cidr}"
  }

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat_a.id}"
  }

  tags {
    Name = "${var.vpc_name} private route table a"
    stream = "${var.stream_tag}"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = "${aws_vpc.default.id}"

  route {
      vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_to_parent.id}"
      cidr_block = "${var.aws_parent_vpc_cidr}"
  }

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat_b.id}"
  }

  tags {
    Name = "${var.vpc_name} private route table b"
    stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${concat(var.aws_region, "a")}"
  cidr_block = "${var.private_subnet_cidr_a}"

  tags {
    Name = "${var.vpc_name}PrivateA"
    stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${concat(var.aws_region, "b")}"
  cidr_block = "${var.private_subnet_cidr_b}"

  tags {
    Name = "${var.vpc_name}PrivateB"
    stream = "${var.stream_tag}"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id = "${aws_subnet.private_a.id}"
  route_table_id = "${aws_route_table.private_a.id}"
}

resource "aws_route_table_association" "private_b" {
  subnet_id = "${aws_subnet.private_b.id}"
  route_table_id = "${aws_route_table.private_a.id}"
}

##############################################################################
# Route 53
##############################################################################

resource "aws_route53_zone" "private_zone" {
  name = "${var.private_hosted_zone_name}"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "Private zone ${var.private_hosted_zone_name}"
    stream = "${var.stream_tag}"
  }
}
