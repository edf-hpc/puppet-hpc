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

# Install the jobsubmit LUA script with gen QOS script and wckeys management
# utility.
#
# @param install_manage    Let this class manage the installation (default:
#                          true)
# @param packages_manage   Let this class installs the packages (default: true)
# @param packages          Array of packages names (default:
#                          ['slurm-llnl-job-submit-plugin'])
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `latest`)
# @param config_manage     Let this class manage the configuration (default:
#                          true)
# @param script_file       Destination path of the lua submit script (default:
#                          '/etc/slurm-llnl/job_submit.lua')
# @param script_source     Source of the script (default:
#                          '/usr/lib/slurm/job_submit.lua')
# @param conf_file         Path of the configuration file (default:
#                          '/etc/slurm-llnl/job_submit.conf')
# @param conf_options      Configuration hash overriding the default parameters
#                          of the module (default: {})
# @param gen_qos_exec      Path to gen qos executable file (default: )
# @param gen_qos_conf      Path to qos configuration file (default:
#                          '/etc/slurm-llnl/qos.conf')
class slurmutils::jobsubmit (
  $install_manage    = $::slurmutils::jobsubmit::params::install_manage,
  $packages_manage   = $::slurmutils::jobsubmit::params::packages_manage,
  $packages          = $::slurmutils::jobsubmit::params::packages,
  $packages_ensure   = $::slurmutils::jobsubmit::params::packages_ensure,
  $config_manage     = $::slurmutils::jobsubmit::params::config_manage,
  $script_file       = $::slurmutils::jobsubmit::params::script_file,
  $script_source     = $::slurmutils::jobsubmit::params::script_source,
  $conf_file         = $::slurmutils::jobsubmit::params::conf_file,
  $conf_options      = {},
  $gen_qos_exec      = $::slurmutils::jobsubmit::params::gen_qos_exec,
  $gen_qos_conf      = $::slurmutils::jobsubmit::params::gen_qos_conf,
) inherits slurmutils::jobsubmit::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $config_manage {
    validate_absolute_path($script_file)
    validate_absolute_path($script_source)
    validate_absolute_path($conf_file)
    validate_hash($conf_options)
    $_conf_options = deep_merge(
      $::slurmutils::jobsubmit::params::conf_options_defaults,
      $conf_options)

    validate_absolute_path($gen_qos_exec)
    validate_absolute_path($gen_qos_conf)
  }

  anchor { 'slurmutils::jobsubmit::begin': } ->
  class { '::slurmutils::jobsubmit::install': } ->
  class { '::slurmutils::jobsubmit::config': } ->
  anchor { 'slurmutils::jobsubmit::end': }
}
