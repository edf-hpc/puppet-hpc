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

# Configure HPCStats Agents
#
# This install jobstats and fsusage agents.
#
# For config options details see:
# http://edf-hpc.github.io/hpcstats/configuration.html#agents-and-launcher
#
# # Hiera autolookups
#  * ```hpcstats::fsusage::config_options```
#  * ```hpcstats::jobstats::config_options```
class profiles::hpcstats::agents {
  include hpcstats::fsusage
  include hpcstats::jobstats
}
