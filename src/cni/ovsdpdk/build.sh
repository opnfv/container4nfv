#!/bin/bash
set -ex

DIR="$(dirname `readlink -f $0`)"
PWD="$(pwd)"

cd $DIR

sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-key adv -k 58118E89F3A912897C070ADBF76221572C52609D
cat << EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=amd64] https://apt.dockerproject.org/repo ubuntu-xenial main
EOF

sudo apt-get install -y --allow-downgrades docker-engine=1.12.6-0~ubuntu-xenial
sudo docker rmi -f cniovsdpdk.build || true
sudo docker build -t cniovsdpdk.build . -f Dockerfile.build
sudo docker run -v $DIR/cni:/build -t cniovsdpdk.build cp /plugins/bin/ovsdpdk /build
sudo docker build -t openretriever/cnicniovsdpdk . -f Dockerfile.cniovsdpdk
sudo rm -rf $DIR/cni/ovsdpdk
echo git clone https://github.com/containernetworking/cni
echo sudo CNI_PATH=$CNI_PATH ./priv-net-run.sh ifconfig
echo sudo docker login openretriever/cnicniovsdpdk -u user -p password
echo sudo docker push openretriever/cnicniovsdpdk
cd $PWD
