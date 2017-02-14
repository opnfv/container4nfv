.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) Xuan Jia (China Mobile)

================================================
OpenRetriever Gap Analysis with OpenStack Mitaka
================================================
This section provides users with OpenRetriever gap analysis regarding feature requirement with Openstack Mitaka Official Release. The following table lists the use cases / feature requirements of container integrated functionality, and its gap analysis with Openstack Mitaka Official Release.

.. table::
  :class: longtable

  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Use Case / Requirement                                     |Supported in Mitaka|Notes                                                               |
  +===========================================================+===================+====================================================================+
  |Manage conainter and virtual machine in the same platform. |No                 |Magnum could provide container environment, but it can't manage     |
  |                                                           |                   |container application. We need a tool to manage applications, no    |
  |                                                           |                   |matter where it is running on container or virutal machine.         |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Container private registry store container images.         |No                 |Container images need to store in container private registry. The   |
  |                                                           |                   |image could be stored in Openstack Cinder or single virtual machine.|
  |                                                           |                   |No matter what, it can fetech container images in this container    |
  |                                                           |                   |environment.                                                        |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Kuryr need to support MACVLAN and IPVLAN                   |No                 |MACVLAN and IPVLAN could get better network performance. In Ocata,  |
  |                                                           |                   |it will support.                                                    |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
 
