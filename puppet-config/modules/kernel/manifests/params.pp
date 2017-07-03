##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2018 EDF S.A.                                      #
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

class kernel::params {

  case $::osfamily {
    'Debian': {
      $sysctl_command = 'systemctl restart systemd-sysctl.service'
    }
    'Redhat': {
      # For RHEL >= 6.2
      $sysctl_command = 'bash -c "source /etc/init.d/functions ; apply_sysctl"'
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }


  $config_manage = true
  $sysctl        = {}
  $sysctl_dir    = '/etc/sysctl.d'
  $udev_rules    = {}
  $udev_dir      = '/etc/udev/rules.d'
  $modprobes     = {}
  $modprobe_dir  = '/etc/modprobe.d'

}
