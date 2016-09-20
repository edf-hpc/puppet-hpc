##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class consul::config inherits consul {

  if $::consul::config_manage {

    file { $::consul::conf_dir:
      ensure => directory,
      owner  => $::consul::system_user,
      group  => $::consul::system_user,
      mode   => 0755,
    }

    file { "${::consul::conf_dir}/10-${::consul::mode}.json" :
      content => template('consul/agent_json.erb'),
      owner   => $::consul::system_user,
      group   => $::consul::system_user,
      mode    => 0644,
      require => File[$::consul::conf_dir],
      notify  => Service[$::consul::services],
    }

    if $::consul::subservices != undef {
      file { "${::consul::conf_dir}/30-services.json" :
        content => template('consul/services_json.erb'),
        owner   => $::consul::system_user,
        group   => $::consul::system_user,
        mode    => 0644,
        require => File[$::consul::conf_dir],
        notify  => Service[$::consul::services],
      }
    }

    file { $::consul::data_dir:
      ensure => directory,
      owner  => $::consul::system_user,
      group  => $::consul::system_user,
      mode   => 0755,
    }

  }
}
