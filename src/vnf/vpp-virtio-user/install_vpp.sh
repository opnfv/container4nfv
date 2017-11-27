#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd /root
apt-get update
apt-get -y install sudo apt-transport-https devscripts git wget vim net-tools
rm -rf vpp
git clone https://gerrit.fd.io/r/vpp
cd vpp
git checkout stable/1707
cp $DIR/patches/01-add-single-file.patch  dpdk/dpdk-17.05_patches
cp $DIR/patches/02-fix-nohuge-option.patch  dpdk/dpdk-17.05_patches
patch -p1 < $DIR/patches/virtio-user.patch
make UNATTENDED=yes install-dep || true
make bootstrap
make build;
find . -type f | grep "install.*bin" | xargs -I {} cp {} /vpp
cp $DIR/startup.conf /vpp
cp $DIR/start.sh /vpp
