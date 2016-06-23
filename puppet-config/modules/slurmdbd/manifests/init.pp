##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2016 EDF S.A.                                      #
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

class slurmdbd (
  $config_manage          = $slurmdbd::params::config_manage,
  $dbbackup_enable        = $slurmdbd::params::dbbackup_enable,
  $bin_dir_path           = $slurmdbd::params::bin_dir_path,
  $conf_dir_path          = $slurmdbd::params::conf_dir_path,
  $logs_dir_path          = $slurmdbd::params::logs_dir_path,
  $main_conf_file         = $slurmdbd::params::main_conf_file,
  $main_conf_options      = $slurmdbd::params::main_conf_options,
  $dbd_conf_file          = $slurmdbd::params::dbd_conf_file,
  $dbd_conf_options       = $slurmdbd::params::dbd_conf_options,
  $dbd_backup_script      = $slurmdbd::params::dbd_backup_script,
  $dbd_backup_src         = $slurmdbd::params::dbd_backup_src,
  $dbd_backup_include     = $slurmdbd::params::dbd_backup_include,
  $backup_include_options = $slurmdbd::params::backup_include_options,
  $package_manage         = $slurmdbd::params::package_manage,
  $package_name           = $slurmdbd::params::package_name,
  $package_ensure         = $slurmdbd::params::package_ensure,
  $service_manage         = $slurmdbd::params::service_manage,
  $service_enable         = $slurmdbd::params::service_enable,
  $service_ensure         = $slurmdbd::params::service_ensure,
  $service_name           = $slurmdbd::params::service_name,

) inherits slurmdbd::params {

  ### Validate params ###
  validate_bool($config_manage)
  validate_bool($package_manage)
  validate_bool($service_manage)

  if $config_manage {
    validate_absolute_path($bin_dir_path)
    validate_absolute_path($conf_dir_path)
    validate_absolute_path($logs_dir_path)
    validate_absolute_path($logs_dir_path)
    validate_absolute_path($main_conf_file)
    validate_hash($main_conf_options)
    validate_absolute_path($dbd_conf_file)
    validate_hash($dbd_conf_options)
    validate_bool($dbbackup_enable)
    if $dbbackup_enable {
      validate_absolute_path($dbd_backup_script)
      validate_absolute_path($dbd_backup_include)
      validate_string($dbd_backup_src)
      validate_hash($backup_include_options)
    }
  }


  if $package_manage {
    validate_array($package_name)
    validate_string($package_ensure)
  }

  if $service_manage {
    validate_bool($service_enable)
    validate_string($service_ensure)
    validate_string($service_name)
  }

  anchor { 'slurmdbd::begin': } ->
  class { '::slurmdbd::install': } ->
  class { '::slurmdbd::config': } ->
  class { '::slurmdbd::service': } ->
  anchor { 'slurmdbd::end': }
}
