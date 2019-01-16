#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
../cleanup.sh
vagrant up
vagrant ssh master -c "/vagrant/istio/istio.sh"
vagrant ssh master -c "/vagrant/multus/multus.sh"
vagrant ssh master -c "/vagrant/kata/nginx-app.sh"
