.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) Xuan Jia (China Mobile)

===============================================
OpenRetriever Gap Analysis with OPNFV Installer
===============================================
This section provides users with OpenRetriever gap analysis regarding feature requirement with OPNFV Installer in Danube Official Release. The following table lists the use cases / feature requirements of container integrated functionality, and its gap analysis with OPNFV Installer in Danube Official Release. OPNFV installer should support them.

.. table::
  :class: longtable

  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Use Case / Requirement                                     |Supported in Danube|Notes                                                               |
  +===========================================================+===================+====================================================================+
  |Use Openstack Magnum to install container environment      |No                 |Magnum is supported in Openstack Official Release, but it's not     |
  |                                                           |                   |supported in OPNFV Installer. Magnum is the place where container   |
  |                                                           |                   |can be installed in OPNFV.                                          |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Use Openstack Ironic to supervise bare metal machine       |No                 |Container could be installed in bare metal machine. Ironic provides |
  |                                                           |                   |bare metal machine, work with Magnum together to setup a container  |
  |                                                           |                   |environment, be installed in OPNFV.                                 |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Use Openstack Kuryr to provide network for container       |No                 |Container has its own network solution. Container needs to connect  |
  |                                                           |                   |with virtual machines, and Kuryr which use Neutron provides network |
  |                                                           |                   |service is the best choice now.                                     |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+

