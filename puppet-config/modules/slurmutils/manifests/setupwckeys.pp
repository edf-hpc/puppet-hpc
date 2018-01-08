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

# Install the slurm-wckeys-setup script.
#
# @param install_manage    Let this class manage the installation (default:
#                          true)
# @param packages_manage   Let this class installs the packages (default: true)
# @param packages          Array of packages names (default:
#                          ['slurm-llnl-setup-wckeys'])
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `latest`)
# @param config_manage     Let this class manage the configuration (default:
#                          true)
# @param wckeysctl_file    Path to wckeysctl configuration file (default:
#                          '/etc/default/wckeysctl')
# @param wckeysctl_options Hash of overriden configuration parameters for
#                          wckeysctl file (default: {})
# @param wckeys_data_files Hash of input files containing wckeys (default: {})
class slurmutils::setupwckeys (
  $install_manage    = $::slurmutils::setupwckeys::params::install_manage,
  $packages_manage   = $::slurmutils::setupwckeys::params::packages_manage,
  $packages          = $::slurmutils::setupwckeys::params::packages,
  $packages_ensure   = $::slurmutils::setupwckeys::params::packages_ensure,
  $config_manage     = $::slurmutils::setupwckeys::params::config_manage,
  $wckeysctl_file    = $::slurmutils::setupwckeys::params::wckeysctl_file,
  $wckeysctl_options = {},
  $wckeys_data_files = $::slurmutils::setupwckeys::params::wckeys_data_files,
) inherits slurmutils::setupwckeys::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $config_manage {
    validate_absolute_path($wckeysctl_file)
    validate_hash($wckeysctl_options)
    validate_hash($wckeys_data_files)
    $_wckeysctl_options = deep_merge(
      $::slurmutils::setupwckeys::params::default_wckeysctl_options,
      $wckeysctl_options)
  }

  anchor { 'slurmutils::setupwckeys::begin': } ->
  class { '::slurmutils::setupwckeys::install': } ->
  class { '::slurmutils::setupwckeys::config': } ->
  anchor { 'slurmutils::setupwckeys::end': }
}
