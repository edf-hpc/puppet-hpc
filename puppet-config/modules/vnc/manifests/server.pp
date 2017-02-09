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

# A VNC server
#
# @param packages Array of packages to install (default: ['tightvncserver'])
# @param packages_ensure Target state for the packages (default: 'installed')
class vnc::server (
  $packages        = $::vnc::server::params::packages,
  $packages_ensure = $::vnc::server::params::packages_ensure,
) inherits vnc::server::params {

  validate_array($packages)
  validate_string($packages_ensure)

  anchor { 'vnc::server::begin': } ->
  class { '::vnc::server::install': } ->
  anchor { 'vnc::server::end': }
}
