Nginx implementation for OPNFV
===============================

This quickstart shows you how to easily install a Kubernetes cluster on VMs running with Vagrant. The installation uses a tool called kubeadm which is part of Kubernetes.

kubeadm assumes you have a set of machines (virtual or bare metal) that are up and running. In this way we can get a cluster with one master node and 2 workers (default). If you want to increase the number of workers nodes, please check the Vagrantfile inside the `kubeadm_basic/`.

About Nginx
-----------
Nginx is a web server which can also be used as a reverse proxy, load balancer and HTTP cache.
