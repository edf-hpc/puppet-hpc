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

# Configure the network on this host
#
# @param packages List of packages for the Intel OmniPath stack
# @param kernel_modules Array of kernel modules to load during server boot
# @param irqbalance_options Key/Value hash with the content of the irqbalance configuration
class opa (
  $packages           = $::opa::params::packages,
  $kernel_modules     = $::opa::params::kernel_modules,
  $irqbalance_options = $::opa::params::irqbalance_options,
) inherits opa::params {

  validate_array($packages)
  validate_array($kernel_modules)
  validate_hash($irqbalance_options)

  anchor { 'opa::begin': } ->
  class { '::opa::install': } ->
  class { '::opa::config': } ~>
  class { '::opa::service': } ->
  anchor { 'opa::end': }

}
