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

define libvirt::network (
  $interface,
  $mode = 'bridge',
){
  validate_string($interface)
  validate_string($mode)
  
  $xml_path = "/var/lib/puppet/libvirt/libvirt_network_${name}.xml"

  ensure_resource(file, '/var/lib/puppet/libvirt', { 'ensure' => 'directory'})

  file { $xml_path:
    ensure  => present,
    content => template('libvirt/network.erb'),
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
  }

  exec { "virsh_net_define_${name}":
    command     => "/usr/bin/virsh net-define --file ${xml_path}",
    refreshonly => true,
    subscribe   => File[$xml_path],
    unless      => "/usr/bin/virsh net-info ${name}",
    before      => [
      Exec["virsh_net_start_${name}"],
      Exec["virsh_net_autostart_${name}"]
    ]
  }

  exec { "virsh_net_start_${name}":
    command     => "/usr/bin/virsh net-start ${name}",
    refreshonly => true,
    subscribe   => File[$xml_path],
    unless      => "/usr/bin/virsh net-info ${name} | tr -d ' ' | grep 'Active:yes'"
  }

  exec { "virsh_net_autostart_${name}":
    command     => "/usr/bin/virsh net-autostart ${name}",
    refreshonly => true,
    subscribe   => File[$xml_path],
  }
  
}
