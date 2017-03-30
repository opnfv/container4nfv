K8S Plugin for Fuel
================================

K8S plugin
-----------------------

Overview
--------

Fuel plugin fuel-plugin-k8s is developed to deploy kubernetes with openstack on
bare metal.


Requirements
------------

| Requirement                      | Version/Comment |
|----------------------------------|-----------------|
| Mirantis OpenStack compatibility | 10.0            |

Recommendations
---------------

None.

Limitations
-----------

None.

Installation Guide
==================

K8S plugin installation
----------------------------------------

1. Clone the fuel-plugin-k8s repo from stackforge:

        git clone https://gerrit.opnfv.org/gerrit/openretriever

2. Install the Fuel Plugin Builder:

        pip install fuel-plugin-builder

3. Build Fuel K8S plugin:

        fpb --build fuel-plugin/

4. The *fuel-plugin-k8s-[x.x.x].rpm* plugin package will be created in the plugin folder.

5. Move this file to the Fuel Master node with secure copy (scp):

        scp fuel-plugin-k8s-[x.x.x].rpm root@<the_Fuel_Master_node_IP address>:/tmp

6. While logged in Fuel Master install the K8S plugin:

        fuel plugins --install fuel-plugin-k8s-[x.x.x].rpm

7. Check if the plugin was installed successfully:

        fuel plugins

        id | name            | version | package_version
        ---|-----------------|---------|----------------
        1  | fuel-plugin-k8s | 0.10.0  | 4.0.0

8. Plugin is ready to use and can be enabled on the Settings tab of the Fuel web UI.


User Guide
==========

K8S plugin configuration
---------------------------------------------

1. Create a new environment with the Fuel UI wizard.
2. Click on the Settings tab of the Fuel web UI.
3. Scroll down the page, select the plugin checkbox.


Testing
-------

None.

Known issues
------------

None.

Contributors
------------

* ruijing.guo@intel.com
