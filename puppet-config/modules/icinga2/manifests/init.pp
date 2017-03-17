##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class icinga2 (
  $install_manage      = $::icinga2::params::install_manage,
  $packages_manage     = $::icinga2::params::packages_manage,
  $packages            = $::icinga2::params::packages,
  $packages_ensure     = $::icinga2::params::packages_ensure,
  $services_manage     = $::icinga2::params::services_manage,
  $services            = $::icinga2::params::services,
  $services_ensure     = $::icinga2::params::services_ensure,
  $services_enable     = $::icinga2::params::services_enable,
  $config_manage       = $::icinga2::params::config_manage,
  $user                = $::icinga2::params::user,
  $crt_host            = $::icinga2::params::crt_host,
  $key_host            = $::icinga2::params::key_host,
  $crt_ca              = $::icinga2::params::crt_ca,
  $local_defs          = $::icinga2::params::local_defs,
  $local_defs_ensure   = $::icinga2::params::local_defs_ensure,
  $zones_file          = $::icinga2::params::zones_file,
  $endpoints           = $::icinga2::params::endpoints,
  $zones               = $::icinga2::params::zones,
  $features            = $::icinga2::params::features,
  $feature_enable_cmd  = $::icinga2::params::feature_enable_cmd,
  $features_avail_dir  = $::icinga2::params::features_avail_dir,
  $features_enable_dir = $::icinga2::params::features_enable_dir,
  $features_conf       = {},
  $ident_dir           = $::icinga2::params::ident_dir,
  $idents              = $::icinga2::params::idents,
  $crt_host_src,
  $key_host_src,
  $crt_ca_src,
  $decrypt_passwd,
  $notif_script,
  $notif_script_src,
  $notif_script_conf,
  $notif_script_conf_src,
) inherits icinga2::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($services_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
    validate_absolute_path($ident_dir)
    validate_hash($idents)
  }

  if $services_manage {
    validate_array($services)
    validate_string($services_ensure)
    validate_bool($services_enable)
  }

  if $install_manage or $config_manage {
    validate_string($user)
  }

  if $config_manage {
    validate_array($local_defs)
    validate_string($local_defs_ensure)
    validate_absolute_path($zones_file)
    validate_hash($endpoints)
    validate_hash($zones)
    validate_array($features)
    validate_string($feature_enable_cmd)
    validate_absolute_path($features_avail_dir)
    validate_absolute_path($features_enable_dir)
    validate_hash($features_conf)
    $_features_conf = deep_merge($::icinga2::params::features_conf,
                                 $features_conf)
  }

  # certificates are usefull only if api feature is enable
  if $install_manage and $config_manage and member($features, 'api') {
    validate_absolute_path($crt_host)
    validate_absolute_path($key_host)
    validate_absolute_path($crt_ca)
    validate_string($crt_host_src)
    validate_string($key_host_src)
    validate_string($crt_ca_src)
    validate_string($decrypt_passwd)
  }

  if $install_manage {
    validate_absolute_path($notif_script)
    validate_absolute_path($notif_script_conf)
    validate_string($notif_script_src)
    validate_string($notif_script_conf_src)
  }
    

  anchor { 'icinga2::begin': } ->
  class { '::icinga2::install': } ->
  class { '::icinga2::config': } ->
  class { '::icinga2::service': } ->
  anchor { 'icinga2::end': }

}
