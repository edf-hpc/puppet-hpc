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

# Install the environment necessary for any node in the userspace
#
# ## Hiera
# * `profiles::environment::userspace::packages`
# * `profiles::environment::userspace::hidepid`
#
# ## Autolookups
# * `hidepid::hidepid`
# * `hidepid::gid`
class profiles::environment::userspace {

  ## Hiera lookups
  $packages = hiera_array('profiles::environment::userspace::packages', [])
  $hidepid  = hiera('profiles::environment::userspace::hidepid', false)

  class { '::base':
    packages => $packages,
  }

  if $hidepid == true {
    ## Hide processes from other users
    class { '::hidepid':
      stage   => 'last',
    }
  }
}
