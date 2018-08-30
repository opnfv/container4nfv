#!/bin/bash
echo "Now build:"
./k8s-build.sh

sleep 2
echo "Now deploy VMs:"
./k8s-deploy.sh

sleep 2
echo "Now deploy vpp_vhostuser:"
./deploy-cni.sh
