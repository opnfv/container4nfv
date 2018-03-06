# Metaswitch Clearwater vIMS Chart

Based on [Metaswitch's Clearwater](https://github.com/Metaswitch/clearwater-docker) k8s configuration.


## Configuration

The following tables lists the configurable parameters of the chart and their default values.


Parameter | Description | Default
--- | --- | ---
`image.path` | dockerhub respository | `enriquetaso`
`image.tag` | docker image tag | `latest`
`config.configmaps` | Custom configmap | `env-vars`
`config.zone` | Custom namespace | `default.svc.cluster.local`
`config.ip` | MANDATORY: Should be repaced with external ip | `None`


