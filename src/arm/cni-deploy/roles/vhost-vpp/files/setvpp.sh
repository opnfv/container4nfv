#!/bin/bash

set -x

cid=`sed -ne '/hostname/p' /proc/1/task/1/mountinfo | awk -F '/' '{print $6}'`
cid_s=${cid:0:12}
filename=${cid_s}-net1.json
ifstring=`cat /vhost-user-net-plugin/${cid}/${cid_s}-net1.json | awk -F ',' '{print $4}'`
ifmac=`echo ${ifstring} | awk -F '\"' '{print $4}'`

ipstr=$(cat /vhost-user-net-plugin/${cid}/${cid_s}-net1-ip4.conf  |grep "ipAddr")
ipaddr=$(echo $ipstr | awk -F '\"' '{print $4}')
ipaddr1=$(echo $ipaddr | cut -d / -f 1)

vdev_str="vdev virtio_user0,path=/vhost-user-net-plugin/$cid/$cid_s-net1,mac=$ifmac"

sed -i.bak '/# dpdk/a\dpdk \{' /etc/vpp/startup.conf
sed -i.bak "/# vdev eth_bond1,mode=1/a\\$vdev_str" /etc/vpp/startup.conf
sed -i.bak '/# socket-mem/a\\}' /etc/vpp/startup.conf

vpp -c /etc/vpp/startup.conf &

sleep 40

vppctl set int state VirtioUser0/0/0 up
vppctl set int ip address VirtioUser0/0/0 ${ipaddr1}/24
vppctl show int
vppctl show int address

echo ${ipaddr1} > /vhost-user-net-plugin/$(hostname)
