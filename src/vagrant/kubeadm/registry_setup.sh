#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/hosts
127.0.0.1    localhost
192.168.1.5  registry
EOF

sudo apt-get update
sudo apt-get install -y docker.io
cat << EOF | sudo tee /etc/docker/daemon.json
{
    "insecure-registries": ["registry:5000"]
}
EOF
sudo service docker restart

sudo docker pull registry:2
sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2
sudo docker build  . -f /vagrant/multus/Dockerfile -t multus-cni
sudo docker tag multus-cni localhost:5000/multus-cni
sudo docker push localhost:5000/multus-cni
