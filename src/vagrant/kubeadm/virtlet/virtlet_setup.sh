#!/bin/bash

set -ex

wget https://github.com/Mirantis/criproxy/releases/download/v0.14.0/criproxy_0.14.0_amd64.deb
echo "criproxy criproxy/primary_cri select containerd" | sudo debconf-set-selections
sudo dpkg -i criproxy_0.14.0_amd64.deb
sudo sed -i "s/EnvironmentFile/#EnvironmentFile/" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload
sudo systemctl restart kubelet
