#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
../cleanup.sh
cp -rf ../../helm-charts/clearwater/ .
vagrant up
vagrant ssh master -c "/vagrant/clearwater_setup.sh"
