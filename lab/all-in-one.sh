#!/bin/bash

set -ex

pushd `dirname ${BASH_SOURCE[0]}`

# Deploy overcloud
export PUBLIC_NETWORK_GW_IP=172.24.4.1
./stack.sh

set +e

# Deploy a test VM
pushd kayobe; ./dev/overcloud-test-vm.sh; popd

# Add non-admin user/project
source labrc.sh
PROJECT_NAME=$OS_PROJECT_NAME
USERNAME=$OS_USERNAME
source adminrc.sh
openstack project create $PROJECT_NAME --or-show
openstack user create $USERNAME --password $OS_PASSWORD --or-show
openstack role add --user $USERNAME --project $PROJECT_NAME member

# Set default gateway on subnet so that traffic from vms can reach outside world
source $LAB_DIR/adminrc.sh
openstack network create public --external --provider-network-type=flat --provider-physical-network physnet1 --share
openstack subnet create public-subnet --ip-version=4 --gateway=$PUBLIC_NETWORK_GW_IP --network public --allocation-pool start=172.24.4.2,end=172.24.4.254 --subnet-range 172.24.4.0/24

# Keypair for lab user
source $LAB_DIR/labrc.sh
openstack keypair create default --public-key ~/.ssh/id_rsa.pub

popd
