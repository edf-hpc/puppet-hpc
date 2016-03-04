##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2015 EDF S.A.                                      #
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

class ntp::params {

  $config       = '/etc/ntp.conf'
  $package_list = [ 'ntp', 'ntpdate' ]
  $service_opts = {
    'NTPD_OPTS' => "'-4 -g'",
  }
  $preferred_servers = []
  $servers = [
    '0.debian.pool.ntp.org',
    '1.debian.pool.ntp.org',
    '2.debian.pool.ntp.org',
    '3.debian.pool.ntp.org',
  ]

  case $::osfamily {
    'Debian': {
      $service_name   = 'ntp'
      $default_config = '/etc/default/ntp'
    }
    'Redhat': {
      $service_name   = 'ntpd'
      $default_config = '/etc/sysconfig/ntpd'
    }
    default: {}
  }
}
