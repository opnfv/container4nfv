.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License. http://creativecommons.org/licenses/by/4.0
.. (c) Gergely Csatari (Nokia)

==================================
OpenRetriever architecture options
==================================

1 Architecture options to support only containers on bare metal
...............................................................
To support containers on bare metal without the support of VM-s only a single
VIM is needed.
This architecture option is targeted by OpenRetriever in OPNFV Euphrates, and
this architecture option is considered in the gap analyzis against
:doc:`OpenStack <gap-analysis-openstack>` and
:doc:`Kubernetes <gap-analysis-kubernetes-v1.5>`.
Examples: Kubernetes, OpenStack with Zun_ and Kuryr_, which as a side effect
also supports VM-s.

2 Architecture options to support containers and VM-s
.....................................................
There are different architecture options to support container based and VM based
VNF-s in OPNFV. This section provides a list of these options with a brief
description and examples.
In the descriptions providing the same API means, that the same set of API-s are
used (like the OpenStack_ API-s or the Kubernetes_ API), integrted networks mean,
that the network connections of the workloads can be connected without leaving
the domain of the VIM and shared hardware resources mean that it is possible to
start a workload VM and a workload container on the same physical host.

2.1 Separate VIM-s
==================
There is a separate VIM for VM-s and a separate for containers, they use
different hardware pools, they provide different API-s and their networks are
not integrated.
Examples: A separate OpenStack instance for the VM-s and a separate Kubernetes_
instance for the containers.

2.2 Single VIM
==============
One VIM supports both VM-s and containers using the same hardware pool, with
the same API and with integrated networking solution.
Examples: OpenStack with Zun_ and Kuryr_ or Kubernetes_ with Kubevirt_, Virtlet_ or
similar.

2.3 Combined VIM-s
==================
There are two VIM-s from API perspective, but usually the VIM-s share hardware
pools on some level. This option have suboptions.

2.3.1 Container VIM on VM VIM
-----------------------------
A container VIM is deployed on top of resources managed by a VM VIM, they share
the same hardware pool, but they have separate domains in the pool, they provide
separate API-s and there are possibilities to integrate their networks.
Example: A Kubernetes_ is deployed into VM-s or bare metal hosts into an
OpenStack deployment optionally with Magnum. Kuryr_ integrates the networks on
some level.

2.3.2 VM VIM on Container VIM
-----------------------------
A VM VIM is deployed on top of resources managed by a container VIM, they do not
share the same hardware pool, provide different API and do not have integrated
networks.
Example: `Kolla Kubernetes <https://github.com/openstack/kolla-kubernetes>`_ or
`OpenStack Helm <https://wiki.openstack.org/wiki/Openstack-helm>`_.

.. _Kubernetes: http://kubernetes.io/
.. _Kubevirt: https://github.com/kubevirt/
.. _Kuryr: https://docs.openstack.org/developer/kuryr/
.. _OpenStack: https://www.openstack.org/
.. _Virtlet: https://github.com/Mirantis/virtlet
.. _Zun: https://wiki.openstack.org/wiki/Zun
