#!/bin/bash

set -ex
DIR="$(dirname `readlink -f $0`)"

cd $DIR
../cleanup.sh
vagrant up
vagrant ssh master -c "/vagrant/clearwater/clearwater_setup.sh"
