##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2017 EDF S.A.                                      #
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

class ldconfig::service inherits ldconfig {

  if ! ( $::osfamily == 'RedHat' and $::operatingsystemmajrelease < 7 ){
    hpclib::systemd_service { "${::ldconfig::service_name}.service":
      target => "/etc/systemd/system/${::ldconfig::service_name}.service",
      config => $::ldconfig::service_definition,
      before => Service[$::ldconfig::service_name]
    }

    $defaults = {
      'unit_name' => "${::ldconfig::service_name}.service",
      'before'    => Service[$::ldconfig::service_name],
    }

    create_resources(::systemd::unit_override, $::ldconfig::service_overrides, $defaults)

    service {$::ldconfig::service_name :
      ensure => $::ldconfig::service_ensure,
      enable => $::ldconfig::service_enable,
    }

  } else {
    notify('ldconfig service is not supported on non systemd OS')
  }
}
