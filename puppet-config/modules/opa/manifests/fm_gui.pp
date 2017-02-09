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

# Intel OmniPAth Fabric Manager Graphical UI
#
# @param packages Array of packages to install (default: ['opa-fmgui'])
# @param packages_ensure Target state for the packages (default: 'installed')
class opa::fm_gui (
  $packages        = $::opa::fm_gui::params::packages,
  $packages_ensure = $::opa::fm_gui::params::packages_ensure,
) inherits opa::fm_gui::params {

  validate_array($packages)
  validate_string($packages_ensure)

  anchor { 'opa::fm_gui::begin': } ->
  class { '::opa::fm_gui::install': } ->
  anchor { 'opa::fm_gui::end': }
}
