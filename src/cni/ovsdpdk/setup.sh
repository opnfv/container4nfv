#!/bin/bash

BUILD=`pwd`

sudo docker build -t cniovsdpdk.build . -f Dockerfile.build
sudo docker run -v $BUILD/cni:/build -ti cniovsdpdk.build cp /plugins/bin/ovsdpdk /build
echo git clone https://github.com/containernetworking/cni
echo sudo CNI_PATH=$CNI_PATH ./priv-net-run.sh ifconfig
sudo docker build -t openretriever/cnicniovsdpdk . -f Dockerfile.cniovsdpdk
#sudo docker push openretriever/cnicniovsdpdk
