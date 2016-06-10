#!/bin/bash
set -e

# Configure the server
cat <<EOF >/tmp/consul.json
{
    "addresses"                   : {
        "http" : "0.0.0.0"
    },
    "recursor"                    : "${dns_server}",
    "disable_anonymous_signature" : true,
    "disable_update_check"        : true,
    "data_dir"                    : "/mnt/consul/data",
    "leave_on_terminate"          : true,
    "ui_dir"                      : "/mnt/consul/ui"
}
EOF
sudo mv /tmp/consul.json /etc/consul.d/consul.json

sudo echo "export CONSUL_FLAGS=\"-server -bootstrap-expect=${num_nodes}\"" > /etc/service/consul

# Setup the init script
cat <<'EOF' >/tmp/upstart
description "Consul server"

start on (runlevel [2345] and started network)
stop on (runlevel [!2345] and stopping network)

respawn

script
  if [ -f "/etc/service/consul" ]; then
    . /etc/service/consul
  fi

  # Make sure to use all our CPUs, because Consul can block a scheduler thread
  export GOMAXPROCS=`nproc`

  # Get the IP
  BIND=`ifconfig eth0 | grep "inet addr" | awk '{ print substr($2,6) }'`
  ADVERTISE=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
  ATLAS_TOKEN=`sudo -H -u ec2-user bash -c 'aws kms decrypt --ciphertext-blob fileb://<(echo '${encrypted_atlas_token}' | base64 -d) --output text --query Plaintext --region ${aws_region} | base64 -d'`

  exec /usr/local/bin/consul agent \
    $${CONSUL_FLAGS} \
    -config-dir="/etc/consul.d" \
    -bind=$${BIND} \
    -advertise-wan=$${ADVERTISE} \
    -data-dir="/mnt/consul/data/" \
    -node="consul-$${BIND}" \
    -dc="${consul_dc}" \
    -atlas=${atlas} \
    -atlas-join \
    -atlas-token=$${ATLAS_TOKEN} \
    >>/var/log/consul.log 2>&1
end script

# to gracefully remove
pre-stop script
    [ -e $PIDFILE ] && kill -INT $(cat $PIDFILE)
    rm -f $PIDFILE
end script
EOF
sudo mv /tmp/upstart /etc/init/consul.conf

# Start Consul
sudo start consul

