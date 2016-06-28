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

# Metrics relay between local cluster and external server 
#
# ## Hiera
# * `profiles::metrics::relay_destination_clusters` (`hiera_array`)
# * `profiles::metrics::relay_match_rules` (`hiera_array`)
# * `profiles::metrics::relay_rewrite_rules` (`hiera_array`)
class profiles::metrics::relay {
  include ::carboncrelay

  $clusters = hiera_hash('profiles::metrics::relay_destination_clusters')
  create_resources(::carboncrelay::cluster, $clusters)

  $match_rules = hiera_hash('profiles::metrics::relay_match_rules')
  create_resources(::carboncrelay::match, $match_rules)

  $rewrite_rules = hiera_hash('profiles::metrics::relay_rewrite_rules')
  create_resources(::carboncrelay::rewrite, $rewrite_rules)
  
}
