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

# Multipath default parameters
class multipath::params {

  $config              = '/etc/multipath.conf'
  $config_opts         = {
    'defaults'             => {
      'user_friendly_names'=> 'yes',
    },
    'blacklist'            => {},
  }
  $paths               = []
  $packages_ensure     = 'present'
  case $::osfamily {
    'Debian': {
      $packages        = ['multipath-tools']
    }
    'Redhat': {
      $packages        = ['device-mapper-multipath']
    }
    default : {
      fail("Unsupported OS Family '${::osfamily}', should be: 'Debian', 'Redhat'.")
    }
  }

}
