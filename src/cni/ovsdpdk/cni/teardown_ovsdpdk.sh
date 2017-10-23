#!/bin/bash

netns=$1
containerid=$2
pid=$(echo $netns | cut -f3 -d"/")

sudo ovs-vsctl del-port br-dpdk vhost-user-$pid
sudo ip netns exec $pid link delete dummy-$pid
sudo rm -rf /var/run/cni/netconf-$pid
