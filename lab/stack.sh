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

# Add non-admin user/project
source ~/labrc.sh
PROJECT_NAME=$OS_PROJECT_NAME
USERNAME=$OS_USERNAME
source ~/adminrc.sh
openstack project create $PROJECT_NAME --or-show
openstack user create $USERNAME --password $OS_PASSWORD --or-show
openstack role add --user $USERNAME --project $PROJECT_NAME member

# Set default gateway on subnet so that traffic from vms can reach outside world
openstack subnet set provision-net --gateway 192.168.33.3
