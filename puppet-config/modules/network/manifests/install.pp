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

class network::install inherits network {

  if $::network::install_manage {

    if $::network::packages_manage {
      package { $::network::_packages:
        ensure => $::network::packages_ensure,
      }
    }

    # On Debian8, install an ifup-hotplug systemd service file
    if $::operatingsystem == 'Debian' and $::operatingsystemmajrelease >= '8' {

      # install ifup hotplug service file and enables it
      hpclib::systemd_service { $::network::ifup_hotplug_service_file :
        target => $::network::ifup_hotplug_service_file,
        config => $::network::ifup_hotplug_service_params,
      }

      # systemd does not run into debian-installer environment. If in this
      # context, create the symlink for the service into the systemd target
      # manually so that it is already enabled in the target at the first boot
      # after the installer.
      if $::puppet_context == 'installer' {
        file { $::network::ifup_hotplug_service_link:
          ensure  => link,
          target  => $::network::ifup_hotplug_service_file,
          require => File[$::network::ifup_hotplug_service_file],
        }
      }
    }
  }

}
