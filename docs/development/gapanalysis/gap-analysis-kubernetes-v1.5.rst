.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.http://creativecommons.org/licenses/by/4.0
.. (c) Xuan Jia (China Mobile)

================================================
OpenRetriever Gap Analysis with Kubernetes v1.5
================================================

This section provides users with OpenRetriever gap analysis regarding feature
requirement with Kubernetes Official Release. The following table lists the use
cases / feature requirements of container integrated functionality, and its gap
analysis with Kubernetes Official Release.

.. table::
  :class: longtable

  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Use Case / Requirement                                     |Supported in v1.5  |Notes                                                               |
  +===========================================================+===================+====================================================================+
  |Manage conainter and virtual machine in the same platform. |No                 |Kubernetes only manage containers. For this part, we need to setup a|
  |                                                           |                   |platform to manage containers and virtual machine together          |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Container uses virt-io to improve performance of container |No                 |Container uses veth currently, but it's so slow to support data     |
  |network                                                    |                   |plane.                                                              |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Kubernetes support mul-network.                            |No                 | As VNF needs at least three interfaces. Management,control plane,  |
  |                                                           |                   | data plane.                                                        |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Kubernetes support SDP/SCDP protocal                       |No                 |SDP is not NAT-aware                                                |
  |                                                           |                   |Kubernetes Service do not support SCTP protocol                     |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Kubernetes scheduling support CPU binding，NUMA features   |No                 |The kubernetes schedular don't support these features               |
  |                                                           |                   |                                                                    |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |DPDK/SR-IOV need to suport CNF(Container Network Interface)|No                 |CNI needs to support SR-IOV / DPDK                                  |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
