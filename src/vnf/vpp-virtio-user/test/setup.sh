#!/bin/bash

set -ex

sudo apt-get update
/src/test/setup_ovsdpdk.sh
sudo apt-get install -y docker.io
sudo docker run -itd --privileged -v /dev/hugepages/:/dev/hugepages/ -v /var/run/openvswitch:/var/run/openvswitch -v /src:/src -v /tmp:/vpp ubuntu:16.04 /src/test/start.sh
sudo docker ps
echo ping -c4 192.168.3.2
