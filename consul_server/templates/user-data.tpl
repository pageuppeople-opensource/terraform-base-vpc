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
    "ui_dir"                      : "/mnt/consul/ui"
}
EOF
sudo mv /tmp/consul.json /etc/consul.d/consul.json

sudo echo "export CONSUL_FLAGS=\"-server -bootstrap-expect=${num_nodes}\"" > /etc/service/consul

# Setup the init script
cat <<'EOF' >/tmp/upstart
description "Consul server"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

script
  if [ -f "/etc/service/consul" ]; then
    . /etc/service/consul
  fi

  # Make sure to use all our CPUs, because Consul can block a scheduler thread
  export GOMAXPROCS=`nproc`

  # Get the IP
  BIND=`ifconfig eth0 | grep "inet addr" | awk '{ print substr($2,6) }'`

  exec /usr/local/bin/consul agent \
    $${CONSUL_FLAGS} \
    -config-dir="/etc/consul.d" \
    -bind=$${BIND} \
    -data-dir="/mnt/consul/data/" \
    -node="consul-$${BIND}" \
    -dc="${consul_dc}" \
    -atlas=${atlas} \
    -atlas-join \
    -atlas-token="${atlas_token}" \
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

