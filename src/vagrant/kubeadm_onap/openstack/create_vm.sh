#!/bin/bash

source ~/devstack/openrc admin admin
netid=$(openstack network list --name private -f value | cut -f1 -d' ')
openstack server create --flavor 1 --image=cirros-0.3.4-x86_64-uec --nic net-id=$netid vm1
