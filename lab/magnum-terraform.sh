#!/bin/bash

# Configure iptable rules
iface=iface=$(ip route | awk '$1 == "default" {print $5; exit}')
sudo iptables -A POSTROUTING -t nat -o $iface -j MASQUERADE
sudo iptables -P FORWARD ACCEPT

# Download and install dependencies
git clone https://github.com/stackhpc/magnum-terraform magnum-terraform
cd magnum-terraform
ln -fs tfvars/kayobe-all-in-one-overcloud.tfvars terraform.tfvars
./install-deps.sh

# Terraform
source ../labrc.sh
./upload-coreos.sh
terraform init
./cluster.sh coreos.tfvars
openstack coe cluster list
