#!/bin/bash
set -ex
DIR="$(dirname `readlink -f $0`)"
cd $DIR

sudo apt-get update
sudo apt-get -y install sudo apt-transport-https devscripts git wget vim net-tools
git clone https://gerrit.fd.io/r/vpp
cd vpp
git checkout stable/1707
cp ../01-add-single-file.patch  dpdk/dpdk-17.05_patches
cp ../02-fix-nohuge-option.patch  dpdk/dpdk-17.05_patches
patch -p1 < ../virtio-user.patch
make UNATTENDED=yes install-dep || true
make bootstrap
make build
mkdir ../bin
cp -r build-root/install-vpp_debug-native/vpp/bin/* ../bin
cp -r build-root/install-vpp_debug-native/dpdk/share/dpdk/usertools/* ../bin
cp -r build-root/install-vpp_debug-native/vpp/lib64/ ../bin
