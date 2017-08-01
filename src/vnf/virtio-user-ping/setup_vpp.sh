#!/bin/bash
mkdir -p /run/vpp
vpp -c /root/startup.conf &
sleep 10
chmod 777 /run/vpp/cli.sock
vppctl set int state VirtioUser0/0/0 up
vppctl set int ip add VirtioUser0/0/0 192.168.3.2/24
sleep 1000000
