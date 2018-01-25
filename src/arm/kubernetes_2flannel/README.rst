.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) OPNFV, arm Limited.

.. _Flannel: https://github.com/coreos/flannel

===============================================
Kubernetes Deployment with 2 Flannel Interfaces
===============================================

The scenario would deploy 2 Flannel_ interfaces for any created pods, in which one interface
named "eth0" would be used as the default interface, and the 2nd interface named "net0" would
route to another subnet.

