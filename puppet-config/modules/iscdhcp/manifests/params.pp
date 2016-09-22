##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2016 EDF S.A.                                      #
#  Contact: CCN-HPC <dsp-cspit-ccn-hpc@edf.fr>                           #
#                                                                        #
#  This program is free software; you can redistribute in and/or         #
#  modify it under the terms of the GNU General Public License,          #
#  version 2, as published by the Free Software Foundation.              #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
##########################################################################

class iscdhcp::params {

  $peer_address               = ''
  $bootmenu_url               = ''
  $ipxebin                    = ''
  $includes                   = {}
  $dhcp_config                = {}
  $packages                   = ['isc-dhcp-server']
  $packages_ensure            = 'present'
  $config_file                = '/etc/dhcp/dhcpd.conf'
  $global_options             = []
  $sharednet                  = {}
  $default_file               = '/etc/default/isc-dhcp-server'
  $default_options            = ['INTERFACES= eth0']
  $service                    = 'isc-dhcp-server'
  $service_ensure             = ''
  $systemd_config_file        = "/etc/systemd/system/${service}.service"
  $systemd_config_options     = {
    'Unit'    => {
      'Description'     => 'ISC DHCP server',
      'After'           => 'network.target',
    },
    'Service' => {
      'Type'            => 'forking',
      'EnvironmentFile' => $default_file,
      'ExecStartPre'    => "/usr/sbin/dhcpd -t \$OPTIONS -cf ${config_file}",
      'ExecStart'       => "/usr/sbin/dhcpd -q \$OPTIONS -cf ${config_file} -pf /var/run/dhcpd.pid \$INTERFACES",
      'PIDFile'         => '/var/run/dhcpd.pid',
      # restart on-failure is needed to retry starting the service until bond0
      # is available. Unfortunately, the after network.target does not do the
      # job, systemd keeps trying to start dhcpd before the network interface
      # is available and it fails. This is the less horrible workaround that
      # has been found so far.
      'Restart'         => 'on-failure',
    },
    'Install' => {
      'WantedBy'        => 'multi-user.target',
    },
  }

}
