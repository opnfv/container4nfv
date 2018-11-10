#!/bin/bash

wget https://github.com/Mirantis/criproxy/releases/download/v0.12.0/criproxy_0.12.0_amd64.deb
sudo dpkg -i criproxy_0.12.0_amd64.deb
sudo sed -i "s/EnvironmentFile/#EnvironmentFile/" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload
sudo systemctl restart kubelet
