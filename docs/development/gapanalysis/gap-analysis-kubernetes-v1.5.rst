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
  |Manage conainter and virtual machine in the same platform. |No                 | There are some ways how Kubernetes could manage VM-s:              |
  |                                                           |                   | 1) Kubevirt [1]                                                    |
  |                                                           |                   | 2) Kubernetes can start rkt and with rkt it is possible to start   |
  |                                                           |                   |    VM-s [2]                                                        |
  |                                                           |                   | 3) Virtlet [3]                                                     |
  |                                                           |                   | 4) Hypercontainer [4]                                              |
  |                                                           |                   |  [1] https://github.com/kubevirt/kubevirt                          |
  |                                                           |                   |  [2] https://coreos.com/rkt/docs/latest/running-kvm-stage1.html    |
  |                                                           |                   |  [3] https://github.com/Mirantis/virtlet                           |
  |                                                           |                   |  [4] https://github.com/kubernetes/frakti                          |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Kubernetes support multiple networks.                      |No                 | As VNF needs at least three interfaces. Management,control plane,  |
  |                                                           |                   |data plane.                                                         |
  |                                                           |                   | (1) Multus https://github.com/Intel-Corp/multus-cni                |
  |                                                           |                   | (2) CNI-Genie https://github.com/Huawei-PaaS/CNI-Genie             |
  |                                                           |                   | (3) A solution built into Kubernetes                               |
  |                                                           |                   | https://docs.google.com/document/d/1TW3P4c8auWwYy-w_5afIPDcGNLK3LZf0m14943eVfVg/ |
  |                                                           |                   | (4) CNI                                                            |
  |                                                           |                   | https://github.com/containernetworking/cni/blob/master/SPEC.md     |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Kubernetes support NAT-less connections to a container     |No                 | SIP/SDP and SCTP are not working with NAT-ed networks              |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |Kubernetes scheduling support CPU binding，NUMA features   |No                 |The kubernetes schedular don't support these features               |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |DPDK need to support CNI                                   |No                 |DPDK is the technology to accelerate the data plane. Container need |
  |                                                           |                   |support it, the same with virtual machine.                          |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
  |SR-IOV can support CNI (Optional)                          |No                 |SR-IOV could let container get high performance                     |
  +-----------------------------------------------------------+-------------------+--------------------------------------------------------------------+
