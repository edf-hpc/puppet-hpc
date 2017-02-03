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
  $db_backup_enable       = $::slurm::dbd::params::db_backup_enable,
  $config_file            = $::slurm::dbd::params::config_file,
  $config_options         = {},
  $db_file                = $::slurm::dbd::params::db_file,
  $db_options             = {},
  $db_manage              = $::slurm::dbd::params::db_manage,
  $db_setup_exec          = $::slurm::dbd::params::db_setup_exec,
  $db_backup_script       = $::slurm::dbd::params::db_backup_script,
  $db_backup_file         = $::slurm::dbd::params::db_backup_file,
  $db_backup_options      = {},
  $sync_enable            = $::slurm::dbd::params::sync_enable,
  $sync_conf_file         = $::slurm::dbd::params::sync_conf_file,
  $sync_options           = {},
  $sync_conf_file         = $::slurm::dbd::params::sync_conf_file,
  $sync_exec              = $::slurm::dbd::params::sync_exec,
  $sync_cron_user         = $::slurm::dbd::params::sync_cron_user,
  $sync_cron_hour         = $::slurm::dbd::params::sync_cron_hour,
  $sync_cron_minute       = $::slurm::dbd::params::sync_cron_minute,
  $sync_pkg_cron          = $::slurm::dbd::params::sync_pkg_cron,
  $sync_pkg_cron_ensure   = $::slurm::dbd::params::sync_pkg_cron_ensure,
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
  validate_bool($db_manage)
  validate_bool($sync_enable)

  if $config_manage {

    validate_absolute_path($config_file)
    validate_hash($config_options)
    validate_absolute_path($db_file)
    validate_absolute_path($db_setup_exec)
    validate_hash($db_options)
    validate_bool($db_backup_enable)

    $_config_options = deep_merge($::slurm::dbd::params::config_options_defaults, $config_options)
    $_db_options = deep_merge($::slurm::dbd::params::db_options_defaults, $db_options)

    if $db_backup_enable {

      validate_absolute_path($db_backup_file)
      validate_hash($db_options)
      validate_hash($db_backup_options)

      $_db_backup_options = deep_merge($::slurm::dbd::params::db_backup_options_defaults, $db_backup_options)
    }

    if $sync_enable {
      validate_absolute_path($sync_conf_file)
      validate_hash($sync_options)
      validate_absolute_path($sync_exec)
      validate_string($sync_cron_user)
      validate_integer($sync_cron_hour)
      validate_integer($sync_cron_minute)
      validate_absolute_path($sync_pkg_cron)
      validate_string($sync_pkg_cron_ensure)

      $_sync_options = deep_merge($::slurm::dbd::params::sync_options_defaults, $sync_options)
    }
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
