#!/bin/bash

# Configure iptable rules
iface=$(route | grep '^default' | grep -o '[^ ]*$')
sudo iptables -A POSTROUTING -t nat -o $iface -j MASQUERADE
sudo iptables -P FORWARD ACCEPT

# Set default gateway on subnet so that traffic from vms can reach outside world
source ~/adminrc.sh
openstack subnet set provision-net --gateway 192.168.33.3

git clone https://github.com/stackhpc/magnum-terraform ~/magnum-terraform
cd ~/magnum-terraform
ln -fs tfvars/kayobe-all-in-one-overcloud.tfvars terraform.tfvars
./install-deps.sh
./upload-coreos.sh
terraform init
./cluster.sh tfvars/coreos.tfvars
openstack coe cluster list
