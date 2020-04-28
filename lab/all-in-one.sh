#!/bin/bash

set -ex

# Apply network configuration (may need to reapply this after a reboot)
./configure-network.sh 192.168.33.3

# Deploy overcloud
export CONFIG_BRANCH=stable/train
./stack.sh

# Deploy a test VM
pushd kayobe; ./dev/overcloud-test-vm.sh; popd
