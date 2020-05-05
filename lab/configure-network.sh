#!/bin/bash

set -x

# Source IPs injected by terraform
source labip.sh

sudo systemctl is-enabled NetworkManager && (sudo dnf -y install network-scripts; sudo systemctl disable NetworkManager ; sudo systemctl enable network ; sudo systemctl stop NetworkManager ; sudo systemctl start network)
sudo systemctl is-enabled firewalld && (sudo systemctl stop firewalld ; sudo systemctl disable firewalld)

# Configure iptable rules
iface=$(ip route | awk '$1 == "default" {print $5; exit}')
sudo iptables -A POSTROUTING -t nat -o $iface -j MASQUERADE
sudo iptables -P FORWARD ACCEPT

# Configure breth1
[[ -z "$CONTROLLER_IP" ]] && echo "CONTROLLER_IP must be present in the environment." && exit 1
sudo ip l add breth1 type bridge
sudo ip l set breth1 up
sudo ip a add $CONTROLLER_IP/24 dev breth1
[[ -z "$PUBLIC_NETWORK_GW_IP" ]] || sudo ip a add $PUBLIC_NETWORK_GW_IP/24 dev breth1
sudo ip l add eth1 type dummy
sudo ip l set eth1 up
sudo ip l set eth1 master breth1

# Configure vxlan0 - not idempotent
if [[ ! -z $LOCAL_IP ]] && [[ ! -z $REMOTE_IP ]]; then
    sudo ip link add vxlan0 type vxlan id 10000 local $LOCAL_IP dstport 4790
    sudo ip link set vxlan0 mtu 1450
    sudo bridge fdb append 00:00:00:00:00:00 dev vxlan0 dst $REMOTE_IP
    sudo ip link set vxlan0 up
    sudo ip link set vxlan0 master breth1
fi
