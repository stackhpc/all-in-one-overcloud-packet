#!/bin/bash

set -x

# Apply network configuration (may need to reapply this after a reboot)
./configure-network.sh

# Disable selinux
sudo dnf install -y selinux-policy-targeted
sudo sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config
sudo setenforce 0

# From https://docs.openstack.org/kayobe/latest/development/automated.html#overcloud
branch=stable/train
git clone https://opendev.org/openstack/kayobe.git -b $branch
cd kayobe
# Checkout the following SHA which doesn't start network.service which causes network breakage
git checkout 4aaaf31a2daeffa42b1cd454e31f35008780319c -b $branch-working
mkdir -p config/src
git clone ${CONFIG_REPO:-https://github.com/stackhpc/kayobe-config-aio} -b ${CONFIG_BRANCH:-stable/train} config/src/kayobe-config

# Update packages
sudo dnf update -y

# Bootstrap and exit if there is error
set -e
./dev/install-dev.sh
./dev/overcloud-deploy.sh
