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

# Install and configures santricity
#
# @param packages        packages list.
# @param packages_ensure packages target state (`present` or `latest`)
class santricity (
  $packages         = $::santricity::params::packages,
  $packages_ensure  = $::santricity::params::packages_ensure,
) inherits santricity::params {
  validate_array($packages)
  validate_string($packages_ensure)


  anchor { 'santricity::begin': } ->
  class { '::santricity::install': } ->
  anchor { 'santricity::end': }

}

