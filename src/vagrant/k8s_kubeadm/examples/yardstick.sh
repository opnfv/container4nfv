#!/usr/bin/env bash

sudo docker run -tid -v /etc/kubernetes/admin.conf:/etc/yardstick/admin.conf --name yardstick opnfv/yardstick:latest
sudo docker exec -ti yardstick yardstick task start yardstick/samples/ping_k8s.yaml
