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

# Deploys Intel Omni-Path fast fabric management tools 
#
# @param packages        Array of packages to install (default:
#                        ['opa-fastfabric'])
# @param packages_ensure Target state for the packages (default: 'installed')
# @param switch_file     Absolute path to the switches list file
#                        (default: '/etc/opa/switches')
# @param switch_source   Source URL for switches file (default: undef)
class opa::ff (
  $packages        = $::opa::ff::params::packages,
  $packages_ensure = $::opa::ff::params::packages_ensure,
  $switch_file     = $::opa::ff::params::switch_file,
  $switch_source   = $::opa::ff::params::switch_source,
) inherits opa::ff::params {

  validate_array($packages)
  validate_string($packages_ensure)

  if $switch_source {
    validate_string($switch_source)
    validate_absolute_path($switch_file)
  }

  anchor { 'opa::ff::begin': } ->
  class { '::opa::ff::install': } ->
  class { '::opa::ff::config': } ~>
  anchor { 'opa::ff::end': }
}
