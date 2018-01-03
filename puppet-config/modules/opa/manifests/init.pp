##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2018 EDF S.A.                                      #
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

# Configure the OPA base stack on this host
#
# @param service_manage  Public class manages the service state (default: true)
# @param service_name    Name of the service to manage (default:
#                        'opa')
# @param service_ensure  Target state for the service (default: 'running')
# @param service_enable  The service starts at boot time (default: true)
# @param packages List of packages for the Intel OmniPath stack
# @param kernel_modules Array of kernel modules to load during server boot
# @param irqbalance_options Key/Value hash with the content of the irqbalance configuration
# @param modprobe_hfi1_manage If true, create the `modprobe_hfi1_file` file
#          (default: true)
# @param modprobe_hfi1_file Path of the modprobe.d file for hfi1 (default:
#          '/etc/modprobe.d/hfi1.conf)
# @param modprobe_hfi1_options Line by line content of the
#          `modprobe_hfi1_file` (default: see params.pp)
# @param modprobe_ib_ipoib_manage If true, create the `modprobe_ib_ipoib_file`
#          file (default: true)
# @param modprobe_ib_ipoib_file Path of the modprobe.d file for ib_ipoib
#          (default: `/etc/modprobe.d/ib_ipoib.conf`)
# @param modprobe_ib_ipoib_options Line by line content of the
#          `modprobe_ib_ipoib_file` (default: see params.pp)

class opa (
  $service_manage            = $::opa::params::service_manage,
  $service_name              = $::opa::params::service_name,
  $service_ensure            = $::opa::params::service_ensure,
  $service_enable            = $::opa::params::service_enable,
  $packages                  = $::opa::params::packages,
  $kernel_modules            = $::opa::params::kernel_modules,
  $irqbalance_options        = $::opa::params::irqbalance_options,
  $modprobe_hfi1_manage      = $::opa::params::modprobe_hfi1_manage,
  $modprobe_hfi1_file        = $::opa::params::modprobe_hfi1_file,
  $modprobe_hfi1_options     = $::opa::params::modprobe_hfi1_options,
  $modprobe_ib_ipoib_manage  = $::opa::params::modprobe_ib_ipoib_manage,
  $modprobe_ib_ipoib_file    = $::opa::params::modprobe_ib_ipoib_file,
  $modprobe_ib_ipoib_options = $::opa::params::modprobe_ib_ipoib_options,
) inherits opa::params {

  validate_bool($service_manage)
  validate_bool($modprobe_hfi1_manage)
  validate_bool($modprobe_ib_ipoib_manage)

  validate_array($packages)
  validate_array($kernel_modules)
  validate_hash($irqbalance_options)

  if $service_manage {
    validate_string($service_name)
    validate_string($service_ensure)
    validate_bool($service_enable)
  }

  if $modprobe_hfi1_manage {
    validate_absolute_path($modprobe_hfi1_file)
    validate_array($modprobe_hfi1_options)
  }
  if $modprobe_ib_ipoib_manage {
    validate_absolute_path($modprobe_ib_ipoib_file)
    validate_array($modprobe_ib_ipoib_options)
  }

  anchor { 'opa::begin': } ->
  class { '::opa::install': } ->
  class { '::opa::config': } ~>
  class { '::opa::service': } ->
  anchor { 'opa::end': }

}
