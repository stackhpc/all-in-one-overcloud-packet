#!/bin/bash

set -x

# Apply network configuration (may need to reapply this after a reboot)
./configure-network.sh ${CONTROLLER_IP:-192.168.33.3} ${EXTERNAL_NETWORK_GW_IP}

# Disable selinux
sudo dnf install -y selinux-policy-targeted
sudo sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config
sudo setenforce 0

# From https://docs.openstack.org/kayobe/latest/development/automated.html#overcloud
git clone https://opendev.org/openstack/kayobe.git -b stable/train
cd kayobe
mkdir -p config/src
git clone ${CONFIG_REPO:-https://github.com/stackhpc/kayobe-config-aio} -b ${CONFIG_BRANCH:-stable/train} config/src/kayobe-config

# Bootstrap and exit if there is error
set -e
./dev/install-dev.sh
./dev/overcloud-deploy.sh
