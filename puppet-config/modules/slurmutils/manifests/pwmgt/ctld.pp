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
# @param priv_key_manage Manage the SSH private key for node stop (default: true)
# @param priv_key_enc Encoded source for the SSH private key (default: undef)
# @parma priv_key_file Path of the SSH private key (default:
#          '/etc/slurm-llnl/pwmgt/ssh_rsa_slurm')
# @param decrypt_passwd Password used to decrypt encoded content
class slurmutils::pwmgt::ctld (
  $install_manage  = $::slurmutils::pwmgt::ctld::params::install_manage,
  $packages_manage = $::slurmutils::pwmgt::ctld::params::packages_manage,
  $packages        = $::slurmutils::pwmgt::ctld::params::packages,
  $packages_ensure = $::slurmutils::pwmgt::ctld::params::packages_ensure,
  $config_manage   = $::slurmutils::pwmgt::ctld::params::config_manage,
  $config_file     = $::slurmutils::pwmgt::ctld::params::config_file,
  $config_options  = {},
  $priv_key_manage = $::slurmutils::pwmgt::ctld::params::priv_key_manage,
  $priv_key_enc    = undef,
  $priv_key_file   = $::slurmutils::pwmgt::ctld::params::priv_key_file,
  $decrypt_passwd  = undef,
) inherits slurmutils::pwmgt::ctld::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $config_manage {
    validate_absolute_path($config_file)
    validate_hash($config_options)
    $_config_options = deep_merge(
      $::slurmutils::pwmgt::ctld::params::config_options_defaults,
      $config_options)

    validate_bool($priv_key_manage)
    if $priv_key_manage {
      validate_absolute_path($priv_key_file)
      if $priv_key_enc {
        validate_string($priv_key_enc)
      } else {
        fail('When priv_key_manage is true, priv_key_enc must be provided.')
      }
      if $decrypt_passwd {
        validate_string($decrypt_passwd)
      } else {
        fail('When priv_key_manage is true, decrypt_passwd must be provided.')
      }
    }
  }

  anchor { 'slurmutils::pwmgt::ctld::begin': } ->
  class { '::slurmutils::pwmgt::ctld::install': } ->
  class { '::slurmutils::pwmgt::ctld::config': } ->
  anchor { 'slurmutils::pwmgt::ctld::end': }
}
