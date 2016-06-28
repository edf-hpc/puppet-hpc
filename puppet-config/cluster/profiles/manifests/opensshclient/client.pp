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

# SSH client default configuration
#
# ## Hiera
# * `cluster`
# * `profiles::opensshclient::main_config_options` (`hiera_array`)
# * `profiles::opensshclient::public_key`
class profiles::opensshclient::client {

  ## Hiera lookups

  $main_config_options = hiera_array('profiles::opensshclient::main_config_options')
  $public_key          = hiera('profiles::opensshclient::public_key')
  $cluster             = hiera('cluster')

  # Pass config options as a class parameter
  class { '::opensshclient':
    main_config_options => $main_config_options,
    cluster             => $cluster,
    public_key          => $public_key,
  }
}
