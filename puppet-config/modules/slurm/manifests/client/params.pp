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

class slurm::client::params {

  ### Package ###
  $packages_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $packages_manage = true
      $packages_name   = ['slurm-sview']
    }
    'Debian': {
      $packages_manage = true
      $packages_name   = ['sview']
    }
    default: {
      $packages_manage = false
    }
  }
}
