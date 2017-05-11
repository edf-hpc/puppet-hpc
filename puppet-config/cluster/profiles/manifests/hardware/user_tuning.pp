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

# Host tuning for user nodes
#
# ## Hiera
# * `profiles::hardware::user_tuning::sysctl` (`hiera_hash`)
class profiles::hardware::user_tuning {

  ## Hiera lookups
  $sysctl = hiera_hash('profiles::hardware::user_tuning::sysctl')

  class { '::kernel':
    sysctl => $sysctl,
  }

}
