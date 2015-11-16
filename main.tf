provider "aws" {
  region = "${var.aws_region}"
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
    Name = "PublicSearchA"
    stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${concat(var.aws_region, "b")}"
  cidr_block = "${var.public_subnet_cidr_b}"

  tags {
    Name = "PublicSearchB"
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
