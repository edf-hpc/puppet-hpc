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
# @param ofed_version Version of ofed to use, 'mlnx' or 'native' (on redhat)
#          (default: mlnx)
# @param packages_manage Public class installs the packages (default: true)
# @param packages List of packages for the Infiniband stack (default depends
#          on the stack selected with ofed_version)
# @param packages_ensure Target state for the packages (default: 'latest')
# @param config_manage Public class manages the configuration (default: true)
# @param ib_file Path of the infiniband stack config file
# @param ib_options Key/Value hash with the content of `ib_file`
# @param systemd_tmpfile tmpfile config file path
# @param systemd_tmpfile_options tmpfile config content as an array of line
# @param mlx4load Load the `mlx4` driver, 'yes'` or 'no' (default: 'yes')
# @param service_manage Public class manages the service state (default: true)
# @param service_name Name of the service to manage (default depends of
#          the ofed_version)
# @param service_ensure Target state for the service (default: 'running')
# @param service_enable The service starts at boot time (default: true)
class infiniband (
  $install_manage          = $::infiniband::params::install_manage,
  $ofed_version            = $::infiniband::params::ofed_version,
  $packages_manage         = $::infiniband::params::packages_manage,
  $packages                = undef,
  $packages_ensure         = $::infiniband::params::packages_ensure,
  $config_manage           = $::infiniband::params::config_manage,
  $ib_file                 = undef,
  $ib_options              = {},
  $mlx4load                = $::infiniband::params::mlx4load,
  $systemd_tmpfile         = $::infiniband::params::systemd_tmpfile,
  $systemd_tmpfile_options = $::infiniband::params::systemd_tmpfile_options,
  $service_manage          = $::infiniband::params::service_manage,
  $service_name            = undef,
  $service_ensure          = $::infiniband::params::service_ensure,
  $service_enable          = $::infiniband::params::service_enable,
) inherits infiniband::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    if $packages {
      validate_array($packages)
      $_packages = $packages
    } else {
      if has_key($::infiniband::params::ofed_packages, $ofed_version) {
        $_packages = $::infiniband::params::ofed_packages[$ofed_version]
      } else {
        $supported_versions = keys($::infiniband::params::ofed_packages)
        fail ("ofed_version: ${ofed_version} not supported on ${::osfamily}, \
               packages supported versions are: ${supported_versions}")
      }
    }
    validate_string($packages_ensure)
  }

  if $config_manage {
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
    if $ib_file {
      validate_absolute_path($ib_file)
      $_ib_file = $ib_file
    } else {
      if has_key($::infiniband::params::ofed_ib_file, $ofed_version) {
        $_ib_file = $::infiniband::params::ofed_ib_file[$ofed_version]
      } else {
        $supported_versions = keys($::infiniband::params::ofed_ib_file)
        fail ("ofed_version: ${ofed_version} not supported on ${::osfamily}, \
               ib_file supported versions are: ${supported_versions}")
      }
    }
  }

  if $service_manage {
    validate_string($service_ensure)
    validate_bool($service_enable)
    if $service_name {
      validate_string($service_name)
      $_service_name = $service_name
    } else {
      if has_key($::infiniband::params::ofed_service_name, $ofed_version) {
        $_service_name = $::infiniband::params::ofed_service_name[$ofed_version]
      } else {
        $supported_versions = keys($::infiniband::params::ofed_service_name)
        fail ("ofed_version: ${ofed_version} not supported on ${::osfamily}, \
               service_name supported versions are: ${supported_versions}")
      }
    }
  }

  anchor { 'infiniband::begin': } ->
  class { '::infiniband::install': } ->
  class { '::infiniband::config': } ~>
  class { '::infiniband::service': } ~>
  anchor { 'infiniband::end': }

}
