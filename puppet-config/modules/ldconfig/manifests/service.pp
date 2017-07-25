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

    $trigger_list = join($::ldconfig::service_triggers, ',')

    $trigger_options = {
      'Install' => {
        'WantedBy' => $trigger_list,
      },
      'Unit' => {
        'After' => $trigger_list,
      },
    }

    $_service_definition = deep_merge($::ldconfig::service_definition, $trigger_options)

    hpclib::systemd_service { "${::ldconfig::service_name}.service":
      target => "/etc/systemd/system/${::ldconfig::service_name}.service",
      config => $_service_definition,
      before => Service[$::ldconfig::service_name]
    } ->
    service {$::ldconfig::service_name :
      ensure => $::ldconfig::service_ensure,
      enable => $::ldconfig::service_enable,
      before => Exec['ldconfig_refresh'],
    }
  } else {
    notify('ldconfig service is not supported on non systemd OS')
  }

  exec { 'ldconfig_refresh':
    command     => '/sbin/ldconfig',
    refreshonly => true,
  }

}
