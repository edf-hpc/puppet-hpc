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

# Deploys the Slurm power management utility
#
# @param pub_key Public SSH key authorized (forced) to launch the stop
#          command, provided without comment or type.
# @param pub_key_type Public SSH key type (default: 'ssh-rsa')
# @param install_manage  Let this class manage the installation (default: true)
# @param packages_manage Let this class installs the packages (default: true)
# @param packages        Array of packages names (default:
#                        ['slurm-llnl-sync-acounts'])
# @param packages_ensure State of the packages (default: `latest`)
# @param config_manage   Let this class manage the configuration (default: true)
# @param config_file     Path of the configuration file (default:
#                        '/etc/slurm-llnl/sync-accounts.conf')
# @param config_options  Configuration hash overriding the default parameters
#                        of the module (default: {})
class slurmutils::pwmgt::exec (
  $pub_key,
  $pub_key_type    = $::slurmutils::pwmgt::exec::params::pub_key_type,
  $install_manage  = $::slurmutils::pwmgt::exec::params::install_manage,
  $packages_manage = $::slurmutils::pwmgt::exec::params::packages_manage,
  $packages        = $::slurmutils::pwmgt::exec::params::packages,
  $packages_ensure = $::slurmutils::pwmgt::exec::params::packages_ensure,
  $config_manage   = $::slurmutils::pwmgt::exec::params::config_manage,
  $config_file     = $::slurmutils::pwmgt::exec::params::config_file,
  $config_options  = {},
) inherits slurmutils::pwmgt::exec::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)
  validate_string($pub_key)
  validate_string($pub_key_type)


  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $config_manage {
    validate_absolute_path($config_file)
    validate_hash($config_options)
    $_config_options = deep_merge(
      $::slurmutils::pwmgt::exec::params::config_options_defaults,
      $config_options)
  }

  anchor { 'slurmutils::pwmgt::exec::begin': } ->
  class { '::slurmutils::pwmgt::exec::install': } ->
  class { '::slurmutils::pwmgt::exec::config': } ->
  anchor { 'slurmutils::pwmgt::exec::end': }
}
