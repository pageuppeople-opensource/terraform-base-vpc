output "public-ip" {
  value = "${aws_instance.bastion.0.public_ip}"
}

output "bastion-ids" {
  value = "${aws_instance.bastion.0.id}"
}
