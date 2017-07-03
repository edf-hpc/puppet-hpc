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

# Deploys ddnsrp stuff.
#
# @param install_manage  Public class manages the installation (default: true)
# @param packages        Array of packages to install (default:
#                        ['ddn-ibsrp', ddn-udev', 'srptools'])
# @param packages_manage Public class installs the packages (default: true)
# @param packages_ensure Target state for the packages (default: 'latest')
# @param init_file       Absolute path to the init script file (default: OS
#                        dependant)
# @param init_src        URL to optional alternate init script (default: undef)
# @param config_manage   Public class manages the configuration (default: true)
# @param module_opts     Array of modprobe configuration lines for the kernel
#                        module (default:
#                        [ 'options ib_srp srp_sg_tablesize=255' ])
# @param service_manage  Public class manages the service state (default: true)
# @param service_name    Name of the service to manage (default:
#                        'ddnsrp-service')
# @param service_ensure  Target state for the service (default: 'running')
# @param service_enable  The service starts at boot time (default: true)

class ddnsrp (
  $install_manage   = $::ddnsrp::params::install_manage,
  $packages_manage  = $::ddnsrp::params::packages_manage,
  $packages         = $::ddnsrp::params::packages,
  $packages_ensure  = $::ddnsrp::params::packages_ensure,
  $init_file        = $::ddnsrp::params::init_file,
  $init_src         = $::ddnsrp::params::init_src,
  $config_manage    = $::ddnsrp::params::config_manage,
  $module_opts      = $::ddnsrp::params::module_opts,
  $service_manage   = $::ddnsrp::params::service_manage,
  $service_name     = $::ddnsrp::params::service_name,
  $service_ensure   = $::ddnsrp::params::service_ensure,
  $service_enable   = $::ddnsrp::params::service_enable,
) inherits ddnsrp::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($service_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $install_manage {
    validate_absolute_path($init_file)
    validate_string($init_src)
  }

  if $config_manage {
    validate_array($module_opts)
  }

  if $service_manage {
    validate_string($service_name)
    validate_string($service_ensure)
    validate_bool($service_enable)
  }

  anchor { 'ddnsrp::begin': } ->
  class { '::ddnsrp::install': } ->
  class { '::ddnsrp::config': } ->
  class { '::ddnsrp::service': } ->
  anchor { 'ddnsrp::end': }

}
