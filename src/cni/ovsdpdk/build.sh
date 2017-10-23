#!/bin/bash
set -ex

HOME="$(dirname `readlink -f $0`)"
PWD="$(pwd)"

cd $HOME
sudo apt-get install -y docker.io
sudo docker rmi -f cniovsdpdk.build || true
sudo docker build -t cniovsdpdk.build . -f Dockerfile.build
sudo docker run -v $HOME/cni:/build -ti cniovsdpdk.build cp /plugins/bin/ovsdpdk /build
sudo docker build -t openretriever/cnicniovsdpdk . -f Dockerfile.cniovsdpdk
sudo rm -rf $HOME/cni/ovsdpdk
echo git clone https://github.com/containernetworking/cni
echo sudo CNI_PATH=$CNI_PATH ./priv-net-run.sh ifconfig
echo sudo docker login openretriever/cnicniovsdpdk -u user -p password
echo sudo docker push openretriever/cnicniovsdpdk
cd $PWD
