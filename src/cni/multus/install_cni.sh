#!/bin/bash

set -ex

export PATH=/usr/local/go/bin:$PATH
apt-get update && apt-get install -y wget
rm -rf multus-cni
wget -qO- https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz | tar -C /usr/local/ -xz
git clone https://github.com/Intel-Corp/multus-cni
cd multus-cni; bash ./build
cp multus-cni/bin/multus /opt/cni/bin
cp /etc/kube-cnimultus/cni-conf.json /etc/cni/net.d/05-multus.conf
