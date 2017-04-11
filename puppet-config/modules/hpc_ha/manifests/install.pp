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

class hpc_ha::install inherits hpc_ha {

  # When a vip resource is instanciated, notify scripts dir
  # will be created in there
  file { '/etc/hpc_ha':
    ensure => directory,
  }

  # Create default notify script for virtual IP addresses
  file { $::hpc_ha::default_notify_script:
    ensure => present,
    source => 'puppet:///modules/hpc_ha/hpc_ha_notify_script.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  hpclib::systemd_service { $hpc_ha::systemd_config_file :
    target => $hpc_ha::systemd_config_file,
    config => $hpc_ha::systemd_config_options,
  }

}

