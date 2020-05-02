#!/bin/bash

set -ex

# Deploy overcloud
./stack.sh

# Deploy a test VM (which also creates provision-net)
pushd kayobe; ./dev/overcloud-test-vm.sh; popd

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
