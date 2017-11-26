#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
../cleanup.sh
vagrant up
vagrant ssh master -c "/vagrant/examples/nginx-app.sh" || (vagrant destroy -f; exit 1)
vagrant destroy -f
