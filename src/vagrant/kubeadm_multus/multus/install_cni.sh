#!/bin/bash

set -ex
cp /cni/multus /opt/cni/bin
cp /etc/kube-cnimultus/cni-conf.json  /etc/cni/net.d/05-multus.conf
while true; do sleep 3600; done
