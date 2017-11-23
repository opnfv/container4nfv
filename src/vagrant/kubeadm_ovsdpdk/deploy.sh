#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
vagrant destroy -f
rm -rf container-ipam-state
vagrant up
vagrant ssh master -c "/vagrant/examples/virtio-user.sh" || (echo vagrant destroy -f; exit 1)
echo vagrant destroy -f
