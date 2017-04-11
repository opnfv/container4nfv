.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.http://creativecommons.org/licenses/by/4.0
.. (c) OPNFV

===================================================
OpenRetriever Gap Analysis with SCTP and Kubernetes
===================================================

This section provides users with OpenRetriever gap analysis regarding SCTP and
Kubernetes.

----
SCTP
----

SCTP is a transport-layer protocol, standardized by IETF RFC 4960. SCTP is
commond protocol in telecom.

---
GAP
---

Kubernetes support service for TCP and UDP protocol but doesn't support SCTP protocol.

--------
Solution
--------

Kube-proxy is enhanced to convert from service IP to one POD IP and SCTP
port is kept same as:

kind: Service
apiVersion: v1
metadata:
  name: mme
spec:
  selector:
    app: mme
  ports:
    - protocol: sctp
      port: 36412

-----------------
Multi-homing(TBD)
-----------------

-------------------
load-balancing(TBD)
-------------------

---------
Reference
---------

http://www.sigcomm.org/node/2753
https://www.ietf.org/proceedings/70/slides/behave-5.pdf
https://tools.ietf.org/html/draft-ietf-tsvwg-natsupp-10
