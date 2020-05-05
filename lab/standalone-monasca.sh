#!/bin/bash

# Reset SECONDS
SECONDS=0

set -ex

pushd `dirname ${BASH_SOURCE[0]}`

# Deploy overcloud
export CONTROLLER_IP=192.168.33.30
export CONFIG_BRANCH=stable/train-standalone-monasca
./stack.sh

popd

set +ex

# Calculate duration
duration=$SECONDS
echo "[INFO] $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
