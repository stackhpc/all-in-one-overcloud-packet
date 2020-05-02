#!/bin/bash

set -ex

# Deploy overcloud
export CONTROLLER_IP=192.168.33.30
export CONFIG_BRANCH=stable/train-standalone-monasca
./stack.sh
