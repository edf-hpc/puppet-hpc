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

# DNS server for the local cluster
#
# ## Hiera
# * `profiles::dns::server::config_options` (`hiera_hash`)
class profiles::dns::server {

  ## Hiera lookups
  $config_options = hiera_hash('profiles::dns::server::config_options')
  $zones = hpc_dns_zones()
  # Pass config options as a class parameter
  class { '::dns::server':
    config_options => $config_options,
    zones          => $zones,
  }
}
