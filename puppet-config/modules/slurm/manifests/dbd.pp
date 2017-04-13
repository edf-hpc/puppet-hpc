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

# Install slurmdbd and configure the database
#
# @param packages_manage   Let this class installs the packages
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `present`)
# @param packages          Array of packages names
# @param service_manage    Let this class run and enable disable the
#                          service (default: true)
# @param service_ensure    Ensure state of the service: `running` or
#                          `stopped` (default: running)
# @param service_enable    Service started at boot (default: true)
# @param service_name      Name of the service
class slurm::dbd (
  $config_manage          = $::slurm::dbd::params::config_manage,
  $config_file            = $::slurm::dbd::params::config_file,
  $config_options         = {},
  $packages_manage        = $::slurm::dbd::params::packages_manage,
  $packages               = $::slurm::dbd::params::packages,
  $packages_ensure        = $::slurm::dbd::params::packages_ensure,
  $service_manage         = $::slurm::dbd::params::service_manage,
  $service_enable         = $::slurm::dbd::params::service_enable,
  $service_ensure         = $::slurm::dbd::params::service_ensure,
  $service_name           = $::slurm::dbd::params::service_name,

) inherits slurm::dbd::params {

  ### Validate params ###
  validate_bool($config_manage)
  validate_bool($packages_manage)
  validate_bool($service_manage)

  if $config_manage {

    validate_absolute_path($config_file)
    validate_hash($config_options)

    $_config_options = deep_merge($::slurm::dbd::params::config_options_defaults, $config_options)

  }

  if $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $service_manage {
    validate_bool($service_enable)
    validate_string($service_ensure)
    validate_string($service_name)
  }

  anchor { 'slurm::dbd::begin': } ->
  class { '::slurm::dbd::install': } ->
  class { '::slurm::dbd::config': } ~>
  class { '::slurm::dbd::service': } ->
  anchor { 'slurmdbd::end': }
}
