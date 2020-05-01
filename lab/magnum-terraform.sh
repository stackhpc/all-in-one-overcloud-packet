#!/bin/bash

# Configure iptable rules
iface=$(route | grep '^default' | grep -o '[^ ]*$')
sudo iptables -A POSTROUTING -t nat -o $iface -j MASQUERADE
sudo iptables -P FORWARD ACCEPT

# Download and install dependencies
git clone https://github.com/stackhpc/magnum-terraform ~/magnum-terraform
cd ~/magnum-terraform
ln -fs tfvars/kayobe-all-in-one-overcloud.tfvars terraform.tfvars
./install-deps.sh
./upload-coreos.sh

# Terraform
source ~/labrc.sh
terraform init
./cluster.sh coreos.tfvars
openstack coe cluster list
