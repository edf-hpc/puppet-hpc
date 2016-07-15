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

# Configure the pam_limits module for resources limits
#
# ## Hiera
# * `profiles::environment::limits_ruleset`
# * `profiles::environment::limits_${ruleset}` (`hiera_hash`), `${ruleset}` is the value of profiles::environment::limits_ruleset
class profiles::environment::limits {
  $ruleset = hiera('profiles::environment::limits_ruleset', undef)

  if $ruleset {
    $config_options = hiera_hash("profiles::environment::limits_${ruleset}")
    class { '::pam::limits':
      config_options => $config_options,
    }
  } else {
    # Just setup limits, rules are coming from autolookup or elswhere
    include ::pam::limits
  }
}
