#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
../cleanup.sh
rm -rf container-ipam-state
vagrant up
vagrant ssh master -c "/vagrant/examples/virtio-user.sh"
