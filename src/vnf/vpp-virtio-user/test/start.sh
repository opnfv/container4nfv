#!/bin/bash

set -ex

/src/install_vpp.sh
mkdir -p /run/vpp
/vpp/vpp -c /vpp/startup.conf &
sleep 10
chmod 777 /run/vpp/cli.sock
/vpp/vppctl set int state VirtioUser0/0/0 up
/vpp/vppctl set int ip add VirtioUser0/0/0 192.168.3.2/24
sleep 1000000
