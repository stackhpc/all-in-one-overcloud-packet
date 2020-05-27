#!/bin/bash

set -x
set +e

# Download and install dependencies
git clone https://github.com/stackhpc/magnum-terraform magnum-terraform

pushd magnum-terraform
ln -fs tfvars/kayobe-all-in-one-overcloud.tfvars terraform.tfvars
./install-deps.sh

# Terraform
source ../labrc.sh
./upload-coreos.sh
terraform init
./cluster.sh coreos.tfvars
openstack coe cluster list

popd
