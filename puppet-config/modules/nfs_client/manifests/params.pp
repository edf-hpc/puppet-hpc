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

class nfs_client::params {

  # Module variables
  $packages_ensure = 'present'
  $service_ensure  = 'running'
  case $::osfamily {
    'Debian': {
      $packages = ['nfs-common']
      $service  = 'nfs-common'
    }
    'Redhat': {
      $packages = ['nfs-utils.x86_64']
      $service  = 'nfs'
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

}
