#!/bin/bash

set -ex
cp /cni/ovsdpdk /opt/cni/bin
cp /cni/setup_ovsdpdk.sh /opt/cni/bin
cp /cni/teardown_ovsdpdk.sh /opt/cni/bin
cp /etc/kube-ovsdpdk/cni-conf.json  /etc/cni/net.d/10-ovsdpdk.conf
while true; do sleep 3600; done
