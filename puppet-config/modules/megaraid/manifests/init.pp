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

# Install and configures megaraid
#
# @param packages        packages list.
# @param packages_ensure packages target state (`present` or `latest`)
class megaraid (
  $packages         = $::megaraid::params::packages,
  $packages_ensure  = $::megaraid::params::packages_ensure,
) inherits megaraid::params {
  validate_array($packages)
  validate_string($packages_ensure)


  anchor { 'megaraid::begin': } ->
  class { '::megaraid::install': } ->
  anchor { 'megaraid::end': }

}

