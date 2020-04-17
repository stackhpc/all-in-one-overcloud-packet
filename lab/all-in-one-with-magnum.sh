#!/bin/bash

set -ex

# Apply network configuration (may need to reapply this after a reboot)
./configure-network.sh 192.168.33.3

# Deploy overcloud
export CONFIG_REPO=https://github.com/stackhpc/kayobe-config-dev
export CONFIG_BRANCH=stable/train-magnum
./stack.sh

# Deploy a test VM
pushd kayobe; ./dev/overcloud-test-vm.sh; popd

# Deploy a Kubernetes cluster via Magnum
./magnum-terraform.sh
