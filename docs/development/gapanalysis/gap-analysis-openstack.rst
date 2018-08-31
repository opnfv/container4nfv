.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License. http://creativecommons.org/licenses/by/4.0
.. (c) Xuan Jia (China Mobile), Gergely Csatari (Nokia)

=========================================
Container4NFV Gap Analysis with OpenStack
=========================================
This section provides a gap analyzis between the targets of Container4NFV for
release Euphrates (E) or later and the features provided by OpenStack in release
Ocata. As the OPNFV and OpenStack releases tend to change over time this
analyzis is planned to be countinously updated.
During the analyzis all OpenStack projects considered.

(**Editors note:** Maybe we should define a scope of OpenStack projects which is
considered. All OpenStack projects can mean anything.)

The following table lists the use cases / feature requirements of container
integrated functionality, and its gap analysis with OpenStack.

.. table::
  :class: longtable

  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+----------------+
  |Use Case / Requirement                                     |Related OpenStack  |Notes                                                               |Status          |
  |                                                           |project            |                                                                    |                |
  +===========================================================+===================+====================================================================+================+
  |Manage container and virtual machine lifecycle with the    |Zun_ or nova-docker|Magnum_ can deploy a Container Orchestration Engine (COE), but does |Open            |
  |same NB API                                                |driver             |not provide any lifecycle management operations to the containers   |                |
  |                                                           |                   |deployed in the COE.                                                |                |
  |                                                           |                   |Zun_ provides lifecycle management support for the containers       |                |
  |                                                           |                   |deployed in the COE via Nova API, but not all COE API operations are|                |
  |                                                           |                   |supported.                                                          |                |
  |                                                           |                   |nova-docker driver provided support for container lifecycle         |                |
  |                                                           |                   |management without a COE (and Magnum), but it was deprecated due to |                |
  |                                                           |                   |lack of community support. A fork of the original nova-docker driver|                |
  |                                                           |                   |is maintained by the Zun team to provide support for the sandbox    |                |
  |                                                           |                   |containers.                                                         |                |
  |                                                           |                   |**Note:** Support for this is not targeted in OPNFV release E.      |                |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+----------------+
  |Container private registry to store container images       |Swift_, Cinder_,   |Container images need a storage backed from where the COE can serve |Open            |
  |                                                           |Glance_, Glare_    |the registry. This backend should be accessible and should be       |                |
  |                                                           |                   |supported by the COE.                                               |                |
  |                                                           |                   |As a workaround it is possible to install a registry backend to a VM|                |
  |                                                           |                   |, but it is more optimal to use the possible backends already       |                |
  |                                                           |                   |available in OpenStack, like Swift_, Cinder_, Glance_ or Glare_.    |                |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+----------------+
  |Kuryr_ needs to support MACVLAN and IPVLAN                 |Kuryr_             |Using MACVLAN or IPVLAN could provide better network performance.   |Open            |
  |                                                           |                   |It is planned for Ocata.                                            |                |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+----------------+
  |Kuryr_ Kubernetes_ integration is needed                   |Kuryr_             |It is done in the frame of Container4NFV.                           |Targeted to     |
  |                                                           |                   |                                                                    |OPNFV release E |
  |                                                           |                   |                                                                    |/OpenStack Ocata|
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+----------------+
  |HA support for Kuryr_                                      |Kuryr_             |                                                                    |Targeted to     |
  |                                                           |                   |                                                                    |OPNFV release E |
  |                                                           |                   |                                                                    |/OpenStack Ocata|
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+----------------+
  |HA support for Zun_                                        |Zun_               |                                                                    |Open            |
  |                                                           |                   |                                                                    |                |
  |                                                           |                   |                                                                    |                |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+----------------+


.. _Zun: https://wiki.openstack.org/wiki/Zun
.. _Magnum: https://wiki.openstack.org/wiki/Magnum
.. _Swift: https://wiki.openstack.org/wiki/Swift
.. _Cinder: https://wiki.openstack.org/wiki/Cinder
.. _Kuryr: https://wiki.openstack.org/wiki/Kuryr
.. _Glance: https://wiki.openstack.org/wiki/Glance
.. _Glare: https://github.com/openstack/glare
.. _Kubernetes: https://kubernetes.io/
