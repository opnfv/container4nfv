# Clearwater/OPNFV Helm Chart

Clearwater master and slave cluster utilizing the Metaswitch Kubernetes plugin

* https://github.com/Metaswitch/clearwater-docker/


## Chart Details
This chart will do the following:

* 1 x Astaire pod and svc
* 1 x Base pod and svc
* 1 x Bono pod and svc with port 5062 exposed on an external LoadBalancer
* 3 x Cassandra pod and svc
* 1 x Chronos pod and svc
* 1 x Ellis pod and svc with port 30080 exposed on and external NodePort (Webserver)
* 1 x Homer pod and svc
* 1 x Homestead-prov pod and svc
* 1 x Homestead pod and svc
* 1 x Ralf pod and svc
* 1 x Sprout pod and svc

## Installing the Chart
By default, you need to pass `config.ip` variable:


```bash
$ helm install --set config.ip=$static_ip ./clearwater
```


## Configuration

The following tables lists the configurable parameters of the Clearwater chart and their default values.


| Parameter                         | Description                          | Default                                                                      |
| --------------------------------- | ------------------------------------ | --------------------------------------------------- |
| `config.ip`                       | Bono's Loadbalancer IP               | None                                                |
| `config.configmaps`               | Name of Clearwater's configmaps      | env-vars                                            |
| `config.zone`                     | Domain used by Bono                  | default.svc.cluster.local                           |
| `image.path`                      | Dockerhub username                   | enriquetaso                                         |
| `image.tag`                       | Tag of the docker image              | latest                                              |
