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

# Define a storage pool in libvirt
#
# Only rbd (Ceph Rados Block Device) is supported
#
# @param title Name of the pool in libvirt
# @param hosts Array of hosts of the pool source (mon nodes for ceph)
# @param auth Hash of authentication parameters
# @param type Only 'rbd' is supported (default: 'rbd')
define libvirt::pool (
  $hosts,
  $auth,
  $type = 'rbd',
){
  validate_array($hosts)
  validate_hash($auth)
  validate_string($type)

  $xml_path = "/var/lib/puppet/libvirt/libvirt_pool_${name}.xml"

  ensure_resource(file, '/var/lib/puppet/libvirt', { 'ensure' => 'directory'})

  file { $xml_path:
    ensure  => present,
    content => template('libvirt/pool.erb'),
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
  }

  exec { "virsh_pool_define_${name}":
    command   => "/usr/bin/virsh pool-define --file ${xml_path}",
    subscribe => File[$xml_path],
    unless    => "/usr/bin/virsh pool-info ${name}",
    before    => [
      Exec["virsh_pool_start_${name}"],
      Exec["virsh_pool_autostart_${name}"]
    ]
  }

  exec { "virsh_pool_start_${name}":
    command   => "/usr/bin/virsh pool-start ${name}",
    subscribe => File[$xml_path],
    unless    => "/usr/bin/virsh pool-info ${name} | tr -d ' ' | grep 'State:running'"
  }

  exec { "virsh_pool_autostart_${name}":
    command     => "/usr/bin/virsh pool-autostart ${name}",
    refreshonly => true,
    subscribe   => File[$xml_path],
  }

}
