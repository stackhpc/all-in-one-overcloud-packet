#!/bin/bash

set -x

# Install git
sudo yum install -y git selinux-policy

# Apply network configuration (may need to reapply this after a reboot)
source ~/configure-network.sh

# From https://docs.openstack.org/kayobe/latest/development/automated.html#overcloud
git clone https://opendev.org/openstack/kayobe.git -b stable/train
cd kayobe
mkdir -p config/src
CONFIG_REPO=${CONFIG_REPO:- https://opendev.org/openstack/kayobe-config-dev.git}
CONFIG_BRANCH=${CONFIG_BRANCH:-stable/train}
git clone $CONFIG_REPO -b $CONFIG_BRANCH config/src/kayobe-config

# Bootstrap and exit if there is error
set -e
./dev/install-dev.sh
./dev/overcloud-deploy.sh
./dev/overcloud-test-vm.sh

# Create a cluster
bash magnum-cluster.sh
