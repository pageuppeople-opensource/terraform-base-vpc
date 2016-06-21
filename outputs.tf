output "id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnets" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private_subnets" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "bastion server public ip a"{
  value = "${module.bastion_server_a.public-ip}"
}

output "bastion server public ip b"{
  value = "${module.bastion_server_b.public-ip}"
}
