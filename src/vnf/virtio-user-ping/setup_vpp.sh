#!/bin/bash

DIR=$(dirname `readlink -f $0`)
export PATH=$DIR/bin:$PATH
export LD_LIBRARY_PATH=$DIR/bin/lib64

id=$(ip a | grep dummy- | cut -f2 -d"-" | cut -f1 -d":")
sed -i "s/vhost-user-1/vhost-user-$id/" $DIR/startup.conf
mkdir -p /run/vpp
vpp -c $DIR/startup.conf &
sleep 10
chmod 777 /run/vpp/cli.sock
vppctl set int state VirtioUser0/0/0 up
ip=$(cut -f6 -d":" /var/run/cni/netconf-$id | cut -f1 -d" ")
vppctl set int ip add VirtioUser0/0/0 $ip/24
sleep 1000000
