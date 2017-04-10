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

# Configure Infiniband
#
# @param install_manage Public class manages the installation (default: true)
# @param packages_manage Public class installs the packages (default: true)
# @param packages List of packages for the Infiniband stack
# @param packages_ensure Target state for the packages (default: 'latest')
# @param config_manage Public class manages the configuration (default: true)
# @param ib_file Path of the infiniband stack config file
# @param ib_options Key/Value hash with the content of `ib_file`
# @param systemd_tmpfile tmpfile config file path
# @param systemd_tmpfile_options tmpfile config content as an array of line
# @param mlx4load Load the `mlx4` driver, 'yes'` or 'no' (default: 'yes')
# @param service_manage Public class manages the service state (default: true)
# @param service_name Name of the service to manage (default: 'openibd')
# @param service_ensure Target state for the service (default: 'running')
# @param service_enable The service starts at boot time (default: true)
class infiniband (
  $install_manage          = $::infiniband::params::install_manage,
  $packages_manage         = $::infiniband::params::packages_manage,
  $packages                = $::infiniband::params::packages,
  $packages_ensure         = $::infiniband::params::packages_manage,
  $config_manage           = $::infiniband::params::config_manage,
  $ib_file                 = $::infiniband::params::ib_file,
  $ib_options              = {},
  $mlx4load                = $::infiniband::params::mlx4load,
  $systemd_tmpfile         = $::infiniband::params::systemd_tmpfile,
  $systemd_tmpfile_options = $::infiniband::params::systemd_tmpfile_options,
  $service_manage          = $::infiniband::params::service_manage,
  $service_name            = $::infiniband::params::service_name,
  $service_ensure          = $::infiniband::params::service_ensure,
  $service_enable          = $::infiniband::params::service_enable,
) inherits infiniband::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    valide_string($packages_ensure)
  }

  if $config_manage {
    validate_absolute_path($ib_file)
    validate_hash($ib_options)
    validate_absolute_path($systemd_tmpfile)
    validate_array($systemd_tmpfile_options)
    validate_string($mlx4load)

    # OpenIB options
    $mlx_options = {
      'mlx4_load'    => $mlx4load,
      'mlx4_en_load' => $mlx4load,
    }
    $_ib_options = merge(
      $::infiniband::params::ib_options_defaults,
      $ib_options,
      $mlx_options
    )
  }

  if $service_manage {
    validate_string($service_name)
    validate_string($service_ensure)
    validate_bool($service_enable)
  }

  anchor { 'infiniband::begin': } ->
  class { '::infiniband::install': } ->
  class { '::infiniband::config': } ~>
  class { '::infiniband::service': } ~>
  anchor { 'infiniband::end': }

}
