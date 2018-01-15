#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/hosts
127.0.0.1    localhost
192.168.0.5  onap
192.168.0.10 master
192.168.0.21 worker1
192.168.0.22 worker2
192.168.0.23 worker3
EOF

sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-key adv -k 58118E89F3A912897C070ADBF76221572C52609D
cat << EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=amd64] https://apt.dockerproject.org/repo ubuntu-xenial main
EOF
export http_proxy=192.168.39.9:8118
export https_proxy=192.168.39.9:8118
curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
unset http_proxy
unset https_proxy

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo touch /etc/apt/apt.conf
cat << EOF | sudo tee /etc/apt/apt.conf
Acquire::http::Proxy "http://192.168.39.9:8118";
EOF

sudo apt-get update
sudo apt-get install -y --allow-downgrades docker-engine=1.12.6-0~ubuntu-xenial kubelet=1.7.0-00 kubeadm=1.7.0-00 kubectl=1.7.0-00 kubernetes-cni=0.5.1-00

sudo systemctl stop docker
cat << EOF | sudo tee /etc/docker/daemon.json
{
  "storage-driver": "overlay"
}
EOF

sudo mkdir /etc/systemd/system/docker.service.d
cat << EOF | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf
> [Service]
> Environment="HTTP_PROXY=http://192.168.39.9:8118/"
> Environment="HTTPS_PROXY=http://192.168.39.9:8118/"
EOF

sudo systemctl daemon-reload
sudo systemctl start docker

sudo systemctl stop kubelet
sudo rm -rf /var/lib/kubelet
sudo systemctl daemon-reload
sudo systemctl start kubelet
