#!/bin/bash -e

cd ../cni-deploy

DEPLOY_SCENARIO="k8-vpp-nofeature-noha"

export ANSIBLE_HOST_KEY_CHECKING=False

virtualenv .venv
source .venv/bin/activate
pip install ansible==2.6.1

#deploy flannel, multus
ansible-playbook -i inventory/inventory.cfg deploy.yml --tags flannel,multus
#deploy vhost-vpp
ansible-playbook -i inventory/inventory.cfg deploy.yml --tags vhost-vpp
