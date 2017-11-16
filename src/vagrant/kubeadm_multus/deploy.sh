#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
vagrant destroy -f
vagrant up
vagrant ssh master -c "/vagrant/examples/multus.sh" || (vagrant destroy -f; exit 1)
vagrant destroy -f
