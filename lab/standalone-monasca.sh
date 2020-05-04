#!/bin/bash

set -ex

pushd `dirname ${BASH_SOURCE[0]}`

# Deploy overcloud
export CONTROLLER_IP=192.168.33.30
export CONFIG_BRANCH=stable/train-standalone-monasca
./stack.sh

popd
