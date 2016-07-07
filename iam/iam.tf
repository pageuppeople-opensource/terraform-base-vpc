resource "aws_iam_role" "vpc" {
  name               = "${var.search_specific_name}-vpc-kms-role"
  assume_role_policy = "${file("policies/role.json")}"
}

resource "aws_iam_role_policy" "vpc" {
  name     = "${var.search_specific_name}-vpc-kms-policy"
  policy   = "${file("policies/policy.json")}"
  role     = "${aws_iam_role.vpc.id}"
}

//TODO: Has permission to decrpt everthing within this VPC. Thats crap, need to be fixed.
resource "aws_iam_instance_profile" "vpc" {
  name = "${var.search_specific_name}-vpc-kms-profile"
  path = "/"
  roles = ["${aws_iam_role.vpc.name}"]
}
