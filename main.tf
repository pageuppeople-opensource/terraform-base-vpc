provider "aws" {
  region = "${var.aws_region}"
}

##############################################################################
# VPC Peering
##############################################################################

resource "aws_vpc_peering_connection" "vpc_to_parent" {
  peer_owner_id = "${var.aws_peer_owner_id}"
  peer_vpc_id = "${var.aws_parent_vpc_id}"
  vpc_id = "${var.vpc_id}"
  auto_accept = true

  tags {
    Name = "${var.vpc_name} to parent peering"
    stream = "${var.stream_tag}"
  }
}

##############################################################################
# Public Subnets
##############################################################################
/*resource "aws_internet_gateway" "public" {*/
  /*vpc_id = "${var.vpc_id}"*/

  /*tags {*/
    /*Name = "public internet gateway"*/
    /*Stream = "${var.stream_tag}"*/
    /*ServerRole = "GATEWAY"*/
    /*"Cost Center" = "${var.costcenter_tag}"*/
    /*Environment = "${var.environment_tag}"*/
  /*}*/
/*}*/

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    /*gateway_id = "${aws_internet_gateway.public.id}"*/
    gateway_id = "${var.internet_gateway_id}"
  }

  tags {
    Name = "public route table"
    Stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${concat(var.aws_region, "a")}"
  cidr_block = "${var.public_subnet_cidr_a}"

  tags {
    Name = "${var.vpc_name} Public A"
    stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${concat(var.aws_region, "b")}"
  cidr_block = "${var.public_subnet_cidr_b}"

  tags {
    Name = "${var.vpc_name} Public B"
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
  name = "nat search"
  description = "NAT search security group"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["${var.nat_subnet_cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.vpc_name} nat security group"
    stream = "${var.stream_tag}"
  }
}

# module plz
resource "aws_instance" "nat_a" {

  # configurable plz
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region we specified
  ami = "${lookup(var.amazon_nat_ami, var.aws_region)}"

  subnet_id = "${aws_subnet.public_a.id}"
  associate_public_ip_address = "true"
  security_groups = ["${aws_security_group.nat.id}"]
  key_name = "${var.public_key_name}"
  count = "1"

  source_dest_check = false

  tags {
    Name = "NAT_server_${var.environment}-a"
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

  # Lookup the correct AMI based on the region we specified
  ami = "${lookup(var.amazon_nat_ami, var.aws_region)}"

  subnet_id = "${aws_subnet.public_a.id}"
  associate_public_ip_address = "true"
  security_groups = ["${aws_security_group.nat.id}"]
  key_name = "${var.public_key_name}"

  source_dest_check = false

  tags {
    Name = "NAT_server_${var.environment}-b"
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
  vpc_id = "${var.vpc_id}"

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
  vpc_id = "${var.vpc_id}"

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
  vpc_id = "${var.vpc_id}"
  availability_zone = "${concat(var.aws_region, "a")}"
  cidr_block = "${var.private_subnet_cidr_a}"

  tags {
    Name = "${var.vpc_name} Private A"
    stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${concat(var.aws_region, "b")}"
  cidr_block = "${var.private_subnet_cidr_b}"

  tags {
    Name = "${var.vpc_name} Private B"
    stream = "${var.stream_tag}"
  }
}

resource "aws_route_table_association" "search_a" {
  subnet_id = "${aws_subnet.private_a.id}"
  route_table_id = "${aws_route_table.private_a.id}"
}

resource "aws_route_table_association" "search_b" {
  subnet_id = "${aws_subnet.private_b.id}"
  route_table_id = "${aws_route_table.private_a.id}"
}

##############################################################################
# Route 53
##############################################################################

resource "aws_route53_zone" "private_zone" {
  name = "${var.private_hosted_zone_name}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "Private zone ${var.private_hosted_zone_name}"
    stream = "${var.stream_tag}"
  }
}
