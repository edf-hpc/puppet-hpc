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

define hpclib::systemd_meta_service(
  $service,
  $source,
  $ensure,
  $enable,
) {

  $service_name = basename($service)
  $service_dir  = dirname($service)

  file { $service_dir :
    ensure => 'directory',
  }

  file { $service :
    ensure => 'link',
    target => $source,
    require => File[$service_dir],
  }

  ### Systemctl execution on supported environments ###
  exec { $service :
    command     => "/bin/systemctl daemon-reload && /bin/systemctl enable ${service_name}",
    refreshonly => true,
    subscribe   => File[$service],
    require     => File[$service],
  }

  $unit_a = split($service_name, '.service$')
  $unit_name = $unit_a[0]
  service { $unit_name :
    ensure  => $ensure,
    enable  => $enable,
    require => Exec[$service],
  }

}
