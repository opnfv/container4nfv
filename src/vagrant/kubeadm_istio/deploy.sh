#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
../cleanup.sh
vagrant up
vagrant ssh master -c "/vagrant/istio/deploy.sh"
vagrant ssh master -c "/vagrant/istio/bookinfo.sh"
vagrant ssh master -c "/vagrant/istio/clean_bookinfo.sh"

