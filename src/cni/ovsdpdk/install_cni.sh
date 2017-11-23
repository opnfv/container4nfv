#!/bin/bash
set -ex


export PATH=/usr/local/go/bin:$PATH

DIR="$(dirname `readlink -f $0`)"
cd $DIR
apt-get update && apt-get install -y git wget gcc
wget -qO- https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz | tar -C /usr/local/ -xz
rm -rf plugins
git clone https://github.com/containernetworking/plugins
cd plugins
git checkout 5544d9ced0d6e908fe26e9dbe529c7feb87d21f5
mkdir plugins/main/ovsdpdk
cp ../ovsdpdk.go plugins/main/ovsdpdk
sed -i "s,PLUGINS=.*,PLUGINS=plugins/main/ovsdpdk," build.sh
./build.sh
mkdir -p /opt/cni/bin
cp bin/ovsdpdk /opt/cni/bin
cp ../setup_ovsdpdk.sh ../teardown_ovsdpdk.sh /opt/cni/bin
rm -rf plugins
