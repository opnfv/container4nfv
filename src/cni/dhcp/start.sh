#!/bin/bash
set -ex

while true
do
    (ip a | grep br-dpdk) && break
    sleep 10
done

service isc-dhcp-server start
while true; do sleep 3600; done
