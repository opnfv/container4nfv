.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) OPNFV, Arm Limited.



===============================================
Container4NFV Openwrt Demo Deployment on Arm Server
===============================================

Abstract
========

This document gives a brief introduction on how to deploy openwrt services with multiple networking interfaces on Arm platform.

Introduction
============
.. _sriov_cni: https://github.com/hustcat/sriov-cni
.. _Flannel: https://github.com/coreos/flannel
.. _Multus:  https://github.com/Intel-Corp/multus-cni
.. _cni:     https://github.com/containernetworking/cni
.. _kubeadm: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
.. _openwrt: https://github.com/openwrt/openwrt

The OpenWrt Project is a Linux operating system targeting embedded devices.
Also it is a famouse open source router project.

We use it as a demo to show how to deploy an open source vCPE in Kubernetes.
For Lan port, we configured flannel cni for it. And for Wan port, we configured sriov cni for it.

For demo purpose, I suggest that we use Kubeadm to deploy a Kubernetes cluster firstly.

Cluster
=======

Cluster Info

In this case, we deploy master and slave as one node.
Suppose it to be: 192.168.1.2

In 192.168.1.2, 2 NIC as required.
Suppose it to be: eth0, eth1. eth0 is used to be controle plane, and eth1 is used to be data plane.

Deploy Kubernetes
-----------------
Please see link(https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) as reference.

Creat CRD
---------
Please make sure that CRD was added for Kubernetes cluster.
Here we name it as crdnetwork.yaml:

::
 apiVersion: apiextensions.k8s.io/v1beta1
 kind: CustomResourceDefinition
 metadata:
   # name must match the spec fields below, and be in the form: <plural>.<group>
   name: networks.kubernetes.com
 spec:
   # group name to use for REST API: /apis/<group>/<version>
   group: kubernetes.com
   # version name to use for REST API: /apis/<group>/<version>
   version: v1
   # either Namespaced or Cluster
   scope: Namespaced
   names:
     # plural name to be used in the URL: /apis/<group>/<version>/<plural>
     plural: networks
     # singular name to be used as an alias on the CLI and for display
     singular: network
     # kind is normally the CamelCased singular type. Your resource manifests use this.
     kind: Network
     # shortNames allow shorter string to match your resource on the CLI
     shortNames:
     - net

command:

::
 kubectl create -f crdnetwork.yaml

Create Flannel-network for Control Plane
----------------------------------------
Create flannel network as control plane.
Here we name it as flannel-network.yaml:

::
 apiVersion: "kubernetes.com/v1"
 kind: Network
 metadata:
   name: flannel-conf
 plugin: flannel
 args: '[
         {
                 "masterplugin": true,
                 "delegate": {
                         "isDefaultGateway": true
                 }
         }
 ]'

command:

::
 kubectl create -f flannel-network.yaml

Create Sriov-network for Data Plane
-----------------------------------
Create sriov network with PF mode as data plane.
Here we name it as sriov-network.yaml:

::
 apiVersion: "kubernetes.com/v1"
 kind: Network
 metadata:
   name: sriov-conf
 plugin: sriov
 args: '[
        {
                 "master": "eth1",
                 "pfOnly": true,
                 "ipam": {
                         "type": "dhcp",
                 }
         }
 ]'

command:

::
 kubectl create -f sriov-network.yaml

CNI Installation
================
.. _CNI: https://github.com/containernetworking/plugins
Firstly, we should deploy all CNI plugins. The build process is following:


::
   git clone https://github.com/containernetworking/plugins.git
   cd plugins
   ./build.sh
   cp bin/* /opt/cni/bin

.. _Multus: https://github.com/Intel-Corp/multus-cni

To deploy control plane and data plane interfaces, besides the Flannel CNI and SRIOV CNI,
we need to deploy the Multus_. The build process of it is as:

::
   git clone https://github.com/Intel-Corp/multus-cni.git
   cd multus-cni
   ./build
   cp bin/multus /opt/cni/bin

To use the Multus_ CNI,
we should put the Multus CNI binary to /opt/cni/bin/ where the Flannel CNI and SRIOV
CNIs are put.

.. _SRIOV: https://github.com/hustcat/sriov-cni
The build process of it is as:

::
  git clone https://github.com/hustcat/sriov-cni.git
  cd sriov-cni
  ./build
  cp bin/* /opt/cni/bin

We also need to enable DHCP client for Wan port.
So we should enable dhcp cni for it.

::
  /opt/cni/bin/dhcp daemon &

CNI Configuration
=================
The following multus CNI configuration is located in /etc/cni/net.d/, here we name it
as multus-cni.conf:

::
 {
   "name": "minion-cni-network",
   "type": "multus",
   "kubeconfig": "/etc/kubernetes/admin.conf",
   "delegates": [{
     "type": "flannel",
     "masterplugin": true,
     "delegate": {
       "isDefaultGateway": true
     }
   }]
 }

command:

::
  step1, remove all files in /etc/cni/net.d/
    rm /etc/cni/net.d/* -rf

  step2, copy /etc/kubernetes/admin.conf into each nodes.

  step3, copy multus-cni.conf into /etc/cni/net.d/

  step4, restart kubelet
    systemctl restart kubelet


Configuring Pod with Control Plane and Data Plane
=================================================

1, Save the below following YAML to openwrt-vpn-multus.yaml.
In this case flannle-conf network object act as the primary network.

::
 apiVersion: v1
 kind: ReplicationController
 metadata:
  name: openwrtvpn1
 spec:
  replicas: 1
  template:
    metadata:
      name: openwrtvpn1
      labels:
        app: openwrtvpn1
      annotations:
        networks: '[
          { "name": "flannel-conf" },
          { "name": "sriov-conf" }
        ]'
    spec:
      containers:
      - name: openwrtvpn1
        image: "younglook/openwrt-demo:arm64"
        imagePullPolicy: "IfNotPresent"
        command: ["/sbin/init"]
        securityContext:
          capabilities:
            add:
              - NET_ADMIN
        stdin: true
        tty: true
        ports:
        - containerPort: 80
        - containerPort: 4500
        - containerPort: 500
 ---
 apiVersion: v1
 kind: Service
 metadata:
  name: openwrtvpn1
 spec:  # specification of the pod's contents
  type: NodePort
  selector:
    app: openwrtvpn1
  ports: [
    {
      "name": "floatingu",
      "protocol": "UDP",
      "port": 4500,
      "targetPort": 4500
    },
    {
      "name": "actualu",
      "protocol": "UDP",
      "port": 500,
      "targetPort": 500
    },
    {
      "name": "web",
      "protocol": "TCP",
      "port": 80,
      "targetPort": 80
    },
  ]

2, Create Pod

::
 command:
  kubectl create -f openwrt-vpn-multus.yaml

3, Get the details of the running pod from the master

::
 # kubectl get pods
 NAME                   READY     STATUS    RESTARTS   AGE
 openwrtvpn1            1/1       Running   0          30s

Verifying Pod Network
=====================

::
 # kubectl exec openwrtvpn1 -- ip a
 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
 3: eth0@if124: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1450 qdisc noqueue
    link/ether 0a:58:0a:e9:40:2a brd ff:ff:ff:ff:ff:ff
    inet 10.233.64.42/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::8e6:32ff:fed3:7645/64 scope link
       valid_lft forever preferred_lft forever
 4: net0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 52:54:00:d4:d2:e5 brd ff:ff:ff:ff:ff:ff
    inet 192.168.123.2/24 scope global net0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fed4:d2e5/64 scope link
       valid_lft forever preferred_lft forever

Contacts
========

Bin Lu:      bin.lu@arm.com
