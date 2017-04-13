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

# Deploys the SlurmDBD accounting users synchronization utility
#
# @param install_manage  Let this class manage the installation (default: true)
# @param packages_manage Let this class installs the packages (default: true)
# @param packages        Array of packages names (default:
#                        ['slurm-llnl-sync-acounts'])
# @param packages_ensure State of the packages (default: `latest`)
# @param pkg_cron_file   Path to the crontab file provided by the package
#                        (default: '/etc/cron.d/slurm-llnl-sync-accounts')
# @param pkg_cron_ensure State of the crontab file provided by the packages
#                        (default: 'absent')
# @param config_manage   Let this class manage the configuration (default: true)
# @param conf_file       Path of the configuration file (default:
#                        '/etc/slurm-llnl/sync-accounts.conf')
# @param conf_options    Configuration hash overriding the default parameters
#                        of the module (default: {})
# @param cron_exec       Path to the backup executable for cron job (default:
#                        '/usr/sbin/slurm-sync-accounts')
# @param cron_user       System user that runs the cron job (default: 'root')
# @param cron_hour       Hour of cronjob run (default: 13 on second node, 1 on
#                        other nodes)
# @param cron_minute     Minute of cronjob run (default: 0)
class slurmutils::syncusers (
  $install_manage  = $::slurmutils::syncusers::params::install_manage,
  $packages_manage = $::slurmutils::syncusers::params::packages_manage,
  $packages        = $::slurmutils::syncusers::params::packages,
  $packages_ensure = $::slurmutils::syncusers::params::packages_ensure,
  $pkg_cron_file   = $::slurmutils::syncusers::params::pkg_cron_file,
  $pkg_cron_ensure = $::slurmutils::syncusers::params::pkg_cron_ensure,
  $config_manage   = $::slurmutils::syncusers::params::config_manage,
  $conf_file       = $::slurmutils::syncusers::params::conf_file,
  $conf_options    = {},
  $cron_exec       = $::slurmutils::syncusers::params::cron_exec,
  $cron_user       = $::slurmutils::syncusers::params::cron_user,
  $cron_hour       = $::slurmutils::syncusers::params::cron_hour,
  $cron_minute     = $::slurmutils::syncusers::params::cron_minute,
) inherits slurmutils::syncusers::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $install_manage {
    validate_absolute_path($pkg_cron_file)
    validate_string($pkg_cron_ensure)
  }

  if $config_manage {
    validate_absolute_path($conf_file)
    validate_hash($conf_options)
    $_conf_options = deep_merge(
      $::slurmutils::syncusers::params::conf_options_defaults,
      $conf_options)

    validate_absolute_path($cron_exec)
    validate_string($cron_user)
    validate_integer($cron_hour)
    validate_integer($cron_minute)
  }

  anchor { 'slurmutils::syncusers::begin': } ->
  class { '::slurmutils::syncusers::install': } ->
  class { '::slurmutils::syncusers::config': } ->
  anchor { 'slurmutils::syncusers::end': }
}
