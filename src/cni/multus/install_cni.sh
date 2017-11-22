#!/bin/bash

set -ex

if [ "root" == "$USER" ]
then
    apt-get update
    apt-get install -y git wget
fi

export PATH=$HOME/go/bin:$PATH
rm -rf multus-cni
wget -qO- https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz | tar -C $HOME -xz
git clone https://github.com/Intel-Corp/multus-cni
cd multus-cni; bash ./build
cp multus-cni/bin/multus /opt/cni/bin
cp /etc/kube-cnimultus/cni-conf.json /etc/cni/net.d/05-multus.conf
