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

# Install and configure the system to collect data from FusionInventory
# agents and to push it to the GLPI server
#
# @param hpc_files	  Hash listing the scripts to install (Default: {})
class glpicollector (
  $hpc_files = $glpicollector::params::hpc_files,
) inherits glpicollector::params {

  validate_hash($hpc_files)

  anchor { 'glpicollector::begin': } ->
  class { '::glpicollector::install': } ->
  class { '::glpicollector::config': } ->
  anchor { 'glpicollector::end': }

}
