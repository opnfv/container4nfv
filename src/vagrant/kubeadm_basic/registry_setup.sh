#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/hosts
127.0.0.1    localhost
192.168.1.5  registry
EOF

sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce=18.06.0~ce~3-0~ubuntu
cat << EOF | sudo tee /etc/docker/daemon.json
{
    "insecure-registries": ["registry:5000"]
}
EOF
sudo service docker restart

sudo docker pull registry:2
sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2
sudo docker pull mirantis/virtlet:v1.4.1
sudo docker tag mirantis/virtlet:v1.4.1 localhost:5000/mirantis/virtlet:v1.4.1
sudo docker push localhost:5000/mirantis/virtlet:v1.4.1
sudo docker build  . -f /vagrant/build/Dockerfile.multus -t multus-cni
sudo docker tag multus-cni localhost:5000/multus-cni
sudo docker push localhost:5000/multus-cni
