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

# Deploys the SlurmDBD database backup utility
#
# @param install_manage  Let this class manage the installation (default: true)
# @param packages_manage Let this class installs the packages (default: true)
# @param packages        Array of packages names (default: ['slurmdbd-backup'])
# @param packages_ensure State of the packages (default: `latest`)
# @param config_manage   Let this class manage the configuration (default: true)
# @param conf_file       Path of the configuration file (default:
#                        '/etc/slurm-llnl/slurmdbd-backup.vars')
# @param conf_options    Configuration hash overriding the default parameters
#                        of the module (default: {})
# @param cron_exec       Path to the backup executable for cron job (default:
#                        '/usr/sbin/slurmdbd-backup')
# @param cron_user       System user that runs the cron job (default: 'root')
# @param cron_hour       Hour of cronjob run (default: 14 on second node, 2 on
#                        other nodes)
# @param cron_minute     Minute of cronjob run (default: 0)
class slurmutils::backupdb (
  $install_manage  = $::slurmutils::backupdb::params::install_manage,
  $packages_manage = $::slurmutils::backupdb::params::packages_manage,
  $packages        = $::slurmutils::backupdb::params::packages,
  $packages_ensure = $::slurmutils::backupdb::params::packages_ensure,
  $config_manage   = $::slurmutils::backupdb::params::config_manage,
  $conf_file       = $::slurmutils::backupdb::params::conf_file,
  $conf_options    = {},
  $cron_exec       = $::slurmutils::backupdb::params::cron_exec,
  $cron_user       = $::slurmutils::backupdb::params::cron_user,
  $cron_hour       = $::slurmutils::backupdb::params::cron_hour,
  $cron_minute     = $::slurmutils::backupdb::params::cron_minute,
) inherits slurmutils::backupdb::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $config_manage {
    validate_absolute_path($conf_file)
    validate_hash($conf_options)
    $_conf_options = deep_merge(
      $::slurmutils::backupdb::params::conf_options_defaults,
      $conf_options)

    validate_absolute_path($cron_exec)
    validate_string($cron_user)
    validate_integer($cron_hour)
    validate_integer($cron_minute)
  }

  anchor { 'slurmutils::backupdb::begin': } ->
  class { '::slurmutils::backupdb::install': } ->
  class { '::slurmutils::backupdb::config': } ->
  anchor { 'slurmutils::backupdb::end': }
}
