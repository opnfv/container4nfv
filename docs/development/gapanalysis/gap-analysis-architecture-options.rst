.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License. http://creativecommons.org/licenses/by/4.0
.. (c) Gergely Csatari (Nokia)

==================================
OpenRetriever architecture options
==================================
There are different architecture options to support container based and VM based
NF-s in OPNFV. This section provides a list of these options with a brief
description and examples.

1 Separate VIM-s
================
There is a separate VIM for VM-s and a separate for containers, they use
different hardware pools, they provide different API-s and their networks are
not integrated.
Examples: A separate OpenStack instance for the VM-s and a separate Kubernetes
instance for the containers.

2 Single VIM
============
One VIM supports both VM-s and containers using the same hardware pool, with
the same API and with integrated networking solution.
Examples: OpenStack with Zun and Kuryr or Kubernetes with Kubevirt, Virtlet or
similar.

3 Combined VIM-s
================
There are two VIM-s from API perspective, but usually the VIM-s share hardware
pools on some level. This option have suboptions.

3.1 Container VIM on VM VIM
---------------------------
A container VIM is deployed on top of resources managed by a VM VIM, they share
the same hardware pool, but they have separate domains in the pool, they provide
separate API-s and there are possibilities to integrate their networks.
Example: A Kubernetes is deployed into VM-s or hosts into an OpenStack
deployment. Kuryr integrates the networks on some level.

3.2 VM VIM on Container VIM
---------------------------
A VM VIM is deployed on top of resources managed by a container VIM, they do not
share the same hardware pool, provide different API and do not have integrated
networks.
