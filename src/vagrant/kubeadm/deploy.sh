#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
../cleanup.sh
vagrant up
vagrant ssh master -c "/vagrant/kata/nginx-app.sh"
vagrant ssh master -c "/vagrant/virtlet/virtlet.sh"
