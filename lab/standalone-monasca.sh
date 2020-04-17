#!/bin/bash

set -ex

# Apply network configuration (may need to reapply this after a reboot)
./configure-network.sh 192.168.33.30

# Deploy overcloud
export CONFIG_REPO=https://github.com/stackhpc/kayobe-config-dev
export CONFIG_BRANCH=stable/train-standalone-monasca
./stack.sh
