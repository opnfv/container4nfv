.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) OPNFV, arm Limited.

.. _Flannel: https://github.com/coreos/flannel
.. _SRIOV: https://github.com/hustcat/sriov-cni

===============================================
Kubernetes Deployment with SRIOV CNI 
===============================================

The scenario would deploy pods with SRIOV/Mltus/Flannel CNI. 
In this case, "eth0" would be used as the default interface, and the 2nd interface named "net0" would
used as data plane.

