#!/bin/bash

set -x

# Install git and disable selinux
sudo dnf install -y git selinux-policy-targeted
sudo sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config
sudo setenforce 0

# From https://docs.openstack.org/kayobe/latest/development/automated.html#overcloud
git clone https://opendev.org/openstack/kayobe.git -b stable/train
cd kayobe
mkdir -p config/src
CONFIG_REPO=${CONFIG_REPO:-https://github.com/stackhpc/kayobe-config-dev}
CONFIG_BRANCH=${CONFIG_BRANCH:-stable/train}
git clone $CONFIG_REPO -b $CONFIG_BRANCH config/src/kayobe-config

set -e

# Bootstrap and exit if there is error
./dev/install-dev.sh
./dev/overcloud-deploy.sh
