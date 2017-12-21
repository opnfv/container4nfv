#!/bin/bash
set -ex

source ~/devstack/openrc admin admin
nova-manage cell_v2 discover_hosts
nova-manage cell_v2 map_cell_and_hosts
