output "bastion server public ip a"{
  value = "${module.bastion_server_a.public-ip}"
}

output "bastion server public ip b"{
  value = "${module.bastion_server_b.public-ip}"
}

output "consul server private ips a"{
  value = "${module.consul_servers_a.private-ips}"
}

output "consul server public ips b"{
  value = "${module.consul_servers_b.private-ips}"
}
