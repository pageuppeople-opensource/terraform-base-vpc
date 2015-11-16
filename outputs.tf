output "bastion server public ips a"{
  value = "${module.bastion_servers_a.public-ips}"
}

output "bastion server public ips b"{
  value = "${module.bastion_servers_b.public-ips}"
}

output "consul server private ips a"{
  value = "${module.consul_servers_a.private-ips}"
}

output "consul server public ips b"{
  value = "${module.consul_servers_b.private-ips}"
}
