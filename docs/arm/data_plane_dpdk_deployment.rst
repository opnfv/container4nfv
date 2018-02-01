.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) OPNFV, Arm Limited.



=============================================================
Kubernetes Pods with DPDK Acceration Deployment on Arm Server
=============================================================

Abstract
========

This document gives a brief introduction on how to deploy Pods with DPDK acceration for data plane.

Introduction
============
.. _kubeadm: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
.. _dpdk:    http://dpdk.org

As we know, in some cases we need to deploy Pods with data-plane acceration.
Typically, in production area(5G, Edge computing),
one interface we used for control plane, it usually will be flannel.
For data plane, sriov cni + DPDK has the best throughput and the lowest lantency.
In this case, I will introduce Pod with DPDK acceration firstly.

NIC with SR-IOV capabilities works by introducing the idea of physical functions (PFs)
and virtual functions (VFs).
In general, PF is used by host.
Each VFs can be treated as a separate physical NIC and assigned to one container,
and configured with separate MAC, VLAN and IP, etc.
If we want the best networking performance for Pods, this should be the best solution.

DPDK is a set of libraries and drivers for fast packet processing.
It is designed to run on any processors.
DPDK can greatly boosts packet processing performance and throughput,
allowing more time for data plane applications.
Also it can improve packet processing performance by up to ten times.

For demo purpose, I suggest that we use Kubeadm to deploy a Kubernetes cluster firstly.
Then I will give out a typical deployment scenario.

Basic Information about Environment
===================================

Cluster Info

In this case, we deploy master and slave as one node.
Suppose it to be: 192.168.1.2

In 192.168.1.2, 2 NIC as required.
Suppose it to be: eth0, eth1, eth0 is used to be controle plane, and eth1 is used to be data plane.
Also eth1 should support SRIOV.

Deploy Kubernetes
-----------------
Please see link(https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) as reference.

SRIOV Configuration
-------------------
Please make sure SRIOV VF mode was enabled in your host.

::
 For example
   rmmod ixgb
   modprobe ixgbe max_vfs=8

VFIO and IOMMU Configuration
----------------------------
Please make sure the required pcie devices were binded into vfio-pci.
And IOMMU was optional on Arm64 platform


::
  With driverctl:

  # driverctl -v list-devices | grep -i net
  # driverctl set-override <pci-slot> vfio-pci

  With dpdk_nic_bind (DPDK <= 16.04):

  # modprobe vfio-pci
  # dpdk_nic_bind --status
  # dpdk_nic_bind --bind=vfio-pci <pci-slot>

  With dpdk-devbind (DPDK >= 16.07:

  # modprobe vfio-pci
  # dpdk-devbind --status
  # dpdk-devbind --bind=vfio-pci <pci-slot>

::
  Enable IOMMU

  # IOMMU was enabled as default on Arm64 platform

  Disable IOMMU

  # echo 1 > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode

Hugepage Configuration
----------------------
Please make sure hugepage was enabled in your host.

::
  For example:
  mount -t hugetlbfs nodev /mnt/huge
  echo 4096 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages

Configuring Pod with Control Plane and Data Plane with DPDK Acceration
======================================================================

1, Save the below following YAML to dpdk.yaml.

::
 apiVersion: v1
 kind: Pod
 metadata:
   name: dpdk
 spec:
   nodeSelector:
     beta.kubernetes.io/arch: arm64
   containers:
   - name: dpdk
     image: younglook/dpdk:arm64
     command: [ "bash", "-c", "/usr/bin/l2fwd --huge-unlink -l 6-7 -n 4 --file-prefix=container -- -p 3" ]
     stdin: true
     tty: true
     securityContext:
       privileged: true
     volumeMounts:
     - mountPath: /dev/vfio
       name: vfio
     - mountPath: /mnt/huge
       name: huge
   volumes:
   - name: vfio
     hostPath:
       path: /dev/vfio
   - name: huge
     hostPath:
       path: /mnt/huge

2, Create Pod

::
 command:
  kubectl create -f dpdk.yaml

3, Get the details of the running pod from the master

::
 # kubectl get pods
 NAME                   READY     STATUS    RESTARTS   AGE
 dpdk                   1/1       Running   0          30s

Verifying DPDK Demo Application
===============================

::
 # kubectl logs dpdk
 Port statistics ====================================
 Statistics for port 0 ------------------------------
 Packets sent:                     7743
 Packets received:            675351868
 Packets dropped:             675229528
 Statistics for port 1 ------------------------------
 Packets sent:                     6207
 Packets received:            675240108
 Packets dropped:             675345661
 Aggregate statistics ===============================
 Total packets sent:              13950
 Total packets received:     1350594777
 Total packets dropped:      1350577990
 ====================================================

Contacts
========

Bin Lu:      bin.lu@arm.com
