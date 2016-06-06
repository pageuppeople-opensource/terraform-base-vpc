output "bastion server public ip a"{
  value = "${module.bastion_server_a.public-ip}"
}

output "bastion server public ip b"{
  value = "${module.bastion_server_b.public-ip}"
}

output "bastion server public ip c"{
  value = "${module.bastion_server_c.public-ip}"
}
