#############################################################################
# Consul servers
##############################################################################
resource "aws_security_group" "consul_server" {
  name = "${var.vpc_name}-consul-server"
  description = "Consul server, UI and maintenance."
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]
  }

  ingress {
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]
  }

  ingress {
    from_port = 8300
    to_port = 8300
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8302
    to_port = 8302
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8302
    to_port = 8302
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.vpc_name}-consul-server"
    stream = "${var.stream_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "consul_agent" {
  name = "${var.vpc_name}-consul-agent"
  description = "Consul agents internal traffic."
  vpc_id = "${aws_vpc.default.id}"

  // These are for internal traffic
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
  }

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "udp"
    self = true
  }

  tags {
    Name = "${var.vpc_name}-consul-agent"
    stream = "${var.stream_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "user_data" {
  template = "${file("${path.root}/consul_server/templates/user-data.tpl")}"

  vars {
    dns_server  = "${var.dns_server}"
    num_nodes   = "${var.consul_instances}"
    consul_dc   = "${var.consul_dc}"
    atlas       = "${var.atlas}"
    atlas_token = "${var.atlas_token}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "consul" {
  name_prefix = "${var.vpc_name}-consul-lc-"
  image_id = "${lookup(var.consul_amis, var.aws_region)}"
  instance_type = "${var.consul_instance_type}"
  security_groups = ["${split(",", replace(concat(aws_security_group.consul_server.id, ",", aws_security_group.consul_agent.id, ",", var.additional_security_groups), "/,\\s?$/", ""))}"]
  associate_public_ip_address = true
  ebs_optimized = false
  key_name = "${var.public_key_name}"
  # TODO
  /*iam_instance_profile = "${aws_iam_instance_profile.consul.id}"*/
  user_data = "${template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "consul" {
  availability_zones = ["${split(",", var.consul_availability_zones)}"]
  max_size = "${var.consul_instances}"
  min_size = "${var.consul_instances}"
  desired_capacity = "${var.consul_instances}"
  default_cooldown = 30
  force_delete = true
  launch_configuration = "${aws_launch_configuration.consul.id}"
  # assuming here we create two subnets
  vpc_zone_identifier = ["${aws_subnet.public_a.id}", "${aws_subnet.public_b.id}", "${aws_subnet.public_c.id}"]

  tag {
    key = "Name"
    value = "${format("%s-consul", var.vpc_name)}"
    propagate_at_launch = true
  }
  tag {
    key = "Stream"
    value = "${var.stream_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "ServerRole"
    value = "${var.consul_role_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "Cost Center"
    value = "${var.costcenter_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "${var.environment_tag}"
    propagate_at_launch = true
  }
  load_balancers = ["${aws_elb.consul.name}", "${aws_elb.consul_internal.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "consul_elb" {
  name = "${var.vpc_name}-consul-elb"
  description = "http and https ports mapped to consul"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.external_cidr_blocks)}"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.external_cidr_blocks)}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${split(",", var.external_cidr_blocks)}"]
  }

  tags {
    Name = "${var.vpc_name}-consul-elb"
    stream = "${var.stream_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "consul" {
  name = "${var.vpc_name}-consul-elb"
  security_groups = ["${aws_security_group.consul_elb.id}"]
  subnets = ["${aws_subnet.public_a.id}", "${aws_subnet.public_b.id}", "${aws_subnet.public_c.id}"]

  listener {
    instance_port = 8500
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = 8500
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.ssl_certificate_arn}"
  }

  health_check {
    healthy_threshold = "${var.consul_instances}"
    unhealthy_threshold = "${var.consul_instances}"
    timeout = 10
    target = "TCP:8500"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  internal = false

  tags {
    Name = "consul elb"
    Stream = "${var.stream_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "consul_internal_elb" {
  name = "${var.vpc_name}-consul-internal-elb"
  description = "internal consul elb"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]
  }

  tags {
    Name = "${var.vpc_name}-consul-internal-elb"
    stream = "${var.stream_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "consul_internal" {
  name = "${var.vpc_name}-consul-internal-elb"
  security_groups = ["${aws_security_group.consul_internal_elb.id}"]
  subnets = ["${aws_subnet.public_a.id}", "${aws_subnet.public_b.id}", "${aws_subnet.public_c.id}"]

  listener {
    instance_port = 8500
    instance_protocol = "http"
    lb_port = 8500
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = "${var.consul_instances}"
    unhealthy_threshold = "${var.consul_instances}"
    timeout = 10
    target = "TCP:8500"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  internal = true

  tags {
    Name = "consul internal elb"
    Stream = "${var.stream_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

##############################################################################
# Route 53
##############################################################################

resource "aws_route53_record" "consul_public" {
  zone_id = "${var.consul_public_hosted_zone_id}"
  name = "${var.consul_public_hosted_zone_name}"
  type = "A"

  alias {
    name = "${aws_elb.consul.dns_name}"
    zone_id = "${aws_elb.consul.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "consul_private" {
  zone_id = "${aws_route53_zone.private_zone.id}"
  name = "private.consul"
  type = "A"

  alias {
    name = "${aws_elb.consul_internal.dns_name}"
    zone_id = "${aws_elb.consul_internal.zone_id}"
    evaluate_target_health = true
  }
}

