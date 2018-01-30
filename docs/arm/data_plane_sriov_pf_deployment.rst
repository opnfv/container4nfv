.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) OPNFV, Arm Limited.



===============================================
SRIOV CNI with PF Mode Deployment on Arm Server
===============================================

Abstract
========

This document gives a brief introduction on how to deploy SRIOV CNI with PF mode for data plane.

Introduction
============
.. _sriov_cni: https://github.com/hustcat/sriov-cni
.. _Flannel: https://github.com/coreos/flannel
.. _Multus:  https://github.com/Intel-Corp/multus-cni
.. _cni:     https://github.com/containernetworking/cni
.. _kubeadm: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
.. _k8s-crd: https://kubernetes.io/docs/concepts/api-extension/custom-resources/
.. _arm64:   https://github.com/kubernetes/website/pull/6511
.. _files:   https://github.com/kubernetes/website/pull/6511/files


As we know, in some cases we need to deploy multiple network interfaces
with data-plane acceration for single Pod.
Typically, in production area(5G, Edge computing),
one interface we used for control plane, it usually will be flannel.
For data plane, sriov cni + DPDK has the best throughput and the lowest lantency.
In this case, I will introduce sriov cni with PF mode firstly.
SRIOV with PF mode is always used in Edge computing.
Because sriov NIC is not so common on Edge computing.
And also PF mode is used as vFirewall, vPorxy in data center.

NIC with SR-IOV capabilities works by introducing the idea of physical functions (PFs)
and virtual functions (VFs).
In general, PF is used by host.
Each VFs can be treated as a separate physical NIC and assigned to one container,
and configured with separate MAC, VLAN and IP, etc.
If we want the best networking performance for Pods, this should be the best solution.

For demo purpose, I suggest that we use Kubeadm to deploy a Kubernetes cluster firstly.
Then I will give out a typical deployment scenario with SRIOV data plane interface added.


Use Case Architecture
=====================

Kubelet is responsible for establishing the network interfaces for each pod;
it does this by invoking its configured CNI plugin. 
When Multus is invoked, it recovers pod annotations related to Multus,
in turn, then it uses these annotations to recover a Kubernetes custom resource definition (CRD),
which is an object that informs which plugins to invoke
and the configuration needing to be passed to them.

Basic Information about Environment
===================================

Cluster Info

In this case, we deploy master and slave as one node.
Suppose it to be: 192.168.1.2

In 192.168.1.2, 2 NIC as required.
Suppose it to be: eth0, eth1, eth0 is used to be controle plane, and eth1 is used to be data plane.

Deploy Kubernetes
-----------------
Please see link(https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) as reference.


Rbac Added (optional)
---------------------
Please make sure that rbac was added for Kubernetes cluster.
here we name it as rbac.yaml:

::
 apiVersion: rbac.authorization.k8s.io/v1beta1
 kind: ClusterRoleBinding
 metadata:
   name: fabric8-rbac
 subjects:
   - kind: ServiceAccount
     # Reference to upper's `metadata.name`
     name: default
     # Reference to upper's `metadata.namespace`
     namespace: default
 roleRef:
   kind: ClusterRole
   name: cluster-admin
   apiGroup: rbac.authorization.k8s.io

command:

::
 kubectl create -f rbac.yaml

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
                         "type": "host-local",
                         "subnet": "192.168.123.0/24",
                         "rangeStart": "192.168.123.2",
                         "rangeEnd": "192.168.123.10",
                         "routes": [
                                 { "dst": "0.0.0.0/0" }
                         ],
                         "gateway": "192.168.123.1"
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

To deploy control plane and data plane interfaces, besides the Flannel CNI and SRIOV CNI, we need to deploy the Multus_. The build process of it is as:

::
   git clone https://github.com/Intel-Corp/multus-cni.git
   cd multus-cni
   ./build
   cp bin/multus /opt/cni/bin

To use the Multus_ CNI, we should put the Multus CNI binary to /opt/cni/bin/ where the Flannel CNI and SRIOV 
CNIs are put.

.. _SRIOV: https://github.com/hustcat/sriov-cni
The build process of it is as:

::
  git clone https://github.com/hustcat/sriov-cni.git
  cd sriov-cni
  ./build
  cp bin/* /opt/cni/bin

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

1, Save the below following YAML to pod-sriov.yaml. In this case flannle-conf network object act as the primary network.

::
 apiVersion: v1
 kind: Pod
 metadata:
   name: pod-sriov
   annotations:
     networks: '[
         { "name": "flannel-conf" },
         { "name": "sriov-conf" }
     ]'
 spec:  # specification of the pod's contents
   containers:
   - name: pod-sriov
     image: "busybox"
     command: ["top"]
     stdin: true
     tty: true

2, Create Pod

::
 command:
  kubectl create -f pod-sriov.yaml

3, Get the details of the running pod from the master

::
 # kubectl get pods
 NAME                   READY     STATUS    RESTARTS   AGE
 pod-sriov              1/1       Running   0          30s

Verifying Pod Network
=====================

::
 # kubectl exec pod-sriov -- ip a
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
