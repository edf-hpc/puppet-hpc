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

define libvirt::secret (
  $uuid,
  $value,
  $type = 'ceph',
){
  validate_string($type)
  validate_string($value)
  validate_string($uuid)
  
  $xml_path = "/var/lib/puppet/libvirt/libvirt_secret_${name}.xml"

  ensure_resource(file, '/var/lib/puppet/libvirt', { 'ensure' => 'directory'})

  file { $xml_path:
    ensure  => present,
    content => template('libvirt/secret.erb'),
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
  }

  exec { "virsh_secret_define_${name}":
    command   => "/usr/bin/virsh secret-define --file ${xml_path}",
    subscribe => File[$xml_path],
    unless    => "/usr/bin/virsh secret-dumpxml ${uuid}",
    before    => Exec["virsh_secret_setvalue_${name}"],
  }

  exec { "virsh_secret_setvalue_${name}":
    command   => "/usr/bin/virsh secret-set-value --secret=${uuid} --base64=${value}",
    unless    => "/usr/bin/virsh secret-get-value --secret=${uuid}",
    subscribe => File[$xml_path],
  }

}
