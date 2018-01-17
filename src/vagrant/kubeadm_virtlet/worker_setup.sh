#!/bin/bash

set -ex
sudo kubeadm join --discovery-token-unsafe-skip-ca-verification --token 8c5adc.1cec8dbf339093f0 192.168.1.10:6443 || true

sudo docker pull openretriever/virtlet
sudo docker run --rm openretriever/virtlet tar -c /criproxy | sudo tar -C /usr/local/bin -xv
sudo ln -s /usr/local/bin/criproxy /usr/local/bin/dockershim

sudo mkdir /etc/criproxy
sudo touch /etc/criproxy/node.conf
sudo cp -r /vagrant/virtlet/etc/systemd/system/* /etc/systemd/system/
sudo systemctl stop kubelet
sudo systemctl daemon-reload
sudo systemctl enable criproxy dockershim
sudo systemctl start criproxy dockershim
sudo systemctl daemon-reload
sudo systemctl start kubelet
