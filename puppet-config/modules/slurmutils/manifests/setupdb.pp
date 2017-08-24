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

# Deploys the SlurmDBD database setup utility
#
# @param install_manage  Let this class manage the installation (default: true)
# @param packages_manage Let this class installs the packages (default: true)
# @param packages        Array of packages names (default:
#                        ['slurm-llnl-setup-mysql'])
# @param packages_ensure State of the packages (default: `latest`)
# @param config_manage   Let this class manage the configuration (default: true)
# @param conf_file       Path of the configuration file (default:
#                        '/etc/slurm-llnl/slurm-mysql.conf')
# @param conf_options    Configuration hash overriding the default parameters
#                        of the module (default: {})
# @importers             Array of importer hosts for DB read-only user
#                        (default: undef)
# @param exec_file       Path to the setup utility executable (default:
#                        '/usr/sbin/slurm-mysql-setup')
class slurmutils::setupdb (
  $install_manage    = $::slurmutils::setupdb::params::install_manage,
  $packages_manage   = $::slurmutils::setupdb::params::packages_manage,
  $packages          = $::slurmutils::setupdb::params::packages,
  $packages_ensure   = $::slurmutils::setupdb::params::packages_ensure,
  $config_manage     = $::slurmutils::setupdb::params::config_manage,
  $conf_file         = $::slurmutils::setupdb::params::conf_file,
  $conf_options      = {},
  $importers         = $::slurmutils::setupdb::params::importers,
  $exec_file         = $::slurmutils::setupdb::params::exec_file,
) inherits slurmutils::setupdb::params {

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
    if $importers {
      validate_array($importers)
      $_importers_hash = {
        'hosts' => {
          'importers' => join($importers, ','),
        },
      }
    } else {
      $_importers_hash = undef
    }
    $_conf_options = deep_merge(
      $::slurmutils::setupdb::params::conf_options_defaults,
      $conf_options,
      $_importers_hash)
  }

  validate_absolute_path($exec_file)

  anchor { 'slurmutils::setupdb::begin': } ->
  class { '::slurmutils::setupdb::install': } ->
  class { '::slurmutils::setupdb::config': } ->
  class { '::slurmutils::setupdb::exec': } ->
  anchor { 'slurmutils::setupdb::end': }
}
