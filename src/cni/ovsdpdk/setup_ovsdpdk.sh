#!/bin/bash

netns=$1
containerid=$2
ip=$3
pid=$(echo $netns | cut -f3 -d"/")

sudo ovs-vsctl --may-exist add-br br-dpdk -- set bridge br-dpdk datapath_type=netdev
sudo ovs-vsctl --may-exist add-port br-dpdk vhost-user-$pid -- set Interface vhost-user-$pid type=dpdkvhostuser
sudo ln -sf $netns /var/run/netns/$pid
sudo ip link add dummy-$pid type dummy
sudo ip link set dummy-$pid netns $pid
sudo mkdir -p /var/run/cni
echo $ip | sudo tee /var/run/cni/netconf-$pid
