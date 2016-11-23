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

class tftp::params {

  ### Module variables ###
  $package_ensure    = 'present'
  $service_ensure    = 'running'
  $service_override_defaults = {
    'Service' => {
      # Wait a bit before retrying to start, this wait for interfaces taking
      # some time to start.
      'Restart'    => 'on-failure',
      'RestartSec' => '5s',
    }
  }

  case $::osfamily {
    'RedHat': {
      $packages          = ['tftp-server']
      $service           = 'tftp'
    }
    'Debian': {
      $packages          = ['tftpd-hpa']
      $service           = 'tftpd-hpa'
      $config_file       = '/etc/default/tftpd-hpa'
      $config_options = {
        'TFTP_USERNAME'    => '"tftp"',
        'TFTP_DIRECTORY'   => '"/srv/tftp"',
        'TFTP_ADDRESS'     => '"0.0.0.0:69"',
        'TFTP_OPTIONS'     => '"--secure --verbose --create"',
      }
    }
    default: {
    }
  }
}
