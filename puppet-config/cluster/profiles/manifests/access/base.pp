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

# Basic pam_access configuration
#
# This profile defines options passed to the `pam_access` configuration
# in the file `/etc/security/access.conf`.
#
# There is three sets of options: base, maintenance and production. Base
# is always included, if the boolean `profiles::access::maintenance_mode`
# is set to true in hiera, the maintenance set is loaded, otherwise it's
# production.
#
# Usually, production includes all the users and maintenance only the 
# administrators or pilot users.
#
# ## Hiera
# * `profiles::access::base_options` (`hiera_array`)
# * `profiles::access::maintenance_mode`
# * `profiles::access::maintenance_options` (`hiera_array`)
# * `profiles::access::production_options` (`hiera_array`)
class profiles::access::base {

  ## Hiera lookups
  $base_options = hiera_array('profiles::access::base_options')
  $maintenance_options = hiera_array('profiles::access::maintenance_options')
  $production_options = hiera_array('profiles::access::production_options')

  $maintenance_mode = hiera('profiles::access::maintenance_mode')

  if $maintenance_mode {
    $options = concat($base_options, $maintenance_options)
  } else {
    $options = concat($base_options, $production_options)
  }

  # Pass config options as a class parameter
  include pam
  class { '::pam::access':
    config_options => $options,
  }
}
