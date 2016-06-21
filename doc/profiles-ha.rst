Profiles - HA
*************

role
====

This profile describes HA configuration that are applied to all machine
of the same role. This is done by configuring two hiera hashes:

-  for the virtual IP addresses (failover):

.. code:: yaml

    #### High-Availability Virtual IP addresses ######
    profiles::ha::role_vips:
      clusterloc_misc:
        prefix:      "%{hiera('cluster_prefix')}"    
        net_id:      'clusterloc'  
        router_id:   '121'
        ip_address:  '10.100.2.20' 
        auth_secret: 'SECRET'
      wan_misc:
        prefix:      "%{hiera('cluster_prefix')}"    
        net_id:      'wan'
        router_id:   '122'
        ip_address:  '192.168.42.55'
        auth_secret: 'SECRET' 

-  One for the virtual servers (load balancing):

.. code:: yaml

    profiles::ha::role_vservs:
      wan_front_ssh:
        ip_address:        '192.168.42.57'
        port:              '22'
        vip_name:          'wan_front'  
        real_server_hosts:
          - 'extgenfront1'

