notice('MODULAR: k8s-master-install')
# get options

$network_metadata = hiera_hash('network_metadata')
$k8s_nodes_hash = get_nodes_hash_by_roles($network_metadata, ['k8s-master'])
$k8s_mgmt_ips_hash = get_node_to_ipaddr_map_by_network_role($k8s_nodes_hash, 'management')
$k8s_mgmt_ips = values($k8s_mgmt_ips_hash)

$network_scheme = hiera_hash('network_scheme')
$service_cidr = $network_scheme['endpoints']['br-mgmt']['IP']

$k8s_settings  = hiera_hash('fuel-plugin-k8s')
$pod_network  = $k8s_settings['pod_network']
$pod_network_cidr  = $k8s_settings['pod_network_cidr']

if $operatingsystem == 'Ubuntu' {
      exec { 'install k8s master':
          command => "/etc/fuel/plugins/fuel-plugin-k8s-1.0/k8s-master-install.sh $k8s_mgmt_ips $service_cidr $pod_network $pod_network_cidr",
          path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      }
} elsif $operatingsystem == 'CentOS' {
}
