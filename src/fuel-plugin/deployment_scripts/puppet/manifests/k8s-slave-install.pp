notice('MODULAR: k8s-slave-install')
# get options

$network_metadata = hiera_hash('network_metadata')
$k8s_nodes_hash = get_nodes_hash_by_roles($network_metadata, ['k8s-master'])
$k8s_mgmt_ips_hash = get_node_to_ipaddr_map_by_network_role($k8s_nodes_hash, 'management')
$k8s_mgmt_ips = values($k8s_mgmt_ips_hash)

if $operatingsystem == 'Ubuntu' {
    exec { 'install k8s slave':
        command => "/etc/fuel/plugins/fuel-plugin-k8s-1.0/k8s-slave-install.sh $k8s_mgmt_ips",
        path    => '/usr/bin:/usr/sbin:/bin:/sbin',
    }
} elsif $operatingsystem == 'CentOS' {
}
