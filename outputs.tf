output "id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnets" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private_subnets" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "bastion public ips"{
  value = "${join(",", aws_instance.bastion.*.public-ip)}"
}

