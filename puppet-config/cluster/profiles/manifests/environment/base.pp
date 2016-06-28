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

# Base environment for a cluster host
#
# ## Hiera 
# * `cluster`
# * `profiles::environment::authorized_users_group`
# * `profiles::environment::motd_content` (`hiera_hash`)
class profiles::environment::base {

  ## Hiera lookups

  $motd_content           = hiera_hash('profiles::environment::motd_content')
  $cluster                = hiera('cluster')
  $authorized_users_group = hiera('profiles::environment::authorized_users_group')

  # Pass config options as a class parameter
  class { '::environment':
    motd_content           => $motd_content,
    cluster                => $cluster,
    authorized_users_group => $authorized_users_group,
  }
}
