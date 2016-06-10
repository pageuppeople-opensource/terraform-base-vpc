resource "aws_iam_role" "vpc" {
  name               = "${var.vpc_name}-vpc-kms-role"
  assume_role_policy = "${file("policies/role.json")}"
}

resource "aws_iam_role_policy" "vpc" {
  name     = "${var.vpc_name}-vpc-kms-policy"
  policy   = "${file("policies/policy.json")}"
  role     = "${aws_iam_role.vpc.id}"
}

resource "aws_iam_instance_profile" "vpc" {
  name = "${var.vpc_name}-vpc-kms-profile"
  path = "/"
  roles = ["${aws_iam_role.vpc.name}"]
}
