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

class mariadb (
  $config_manage        = $mariadb::params::config_manage,
  $mariadb_preseed_file = $mariadb::params::mariadb_preseed_file,
  $mariadb_preseed_tmpl = $mariadb::params::mariadb_preseed_tmpl,
  $main_conf_file       = $mariadb::params::main_conf_file,
  $galera_conf_file     = $mariadb::params::galera_conf_file,
  $mysql_conf_options   = $mariadb::params::mysql_conf_options,
  $galera_conf_options  = {},
  $package_manage       = $mariadb::params::package_manage,
  $package_ensure       = $mariadb::params::package_ensure,
  $package_name         = $mariadb::params::package_name,
  $service_manage       = $mariadb::params::service_manage,
  $service_ensure       = $mariadb::params::service_ensure,
  $service_enable       = $mariadb::params::service_enable,
  $service_name         = $mariadb::params::service_name,
  $nodes                = $mariadb::params::nodes,
  $mysql_root_pwd,
) inherits mariadb::params {

  ### Validate params ###
  validate_bool($package_manage)
  validate_bool($config_manage)
  validate_bool($service_manage)
  validate_string($mysql_root_pwd)

  if $package_manage {
    validate_array($package_name)
    validate_string($package_ensure)
  }

  if $config_manage {
    validate_absolute_path($mariadb_preseed_file)
    validate_string($mariadb_preseed_tmpl)
    validate_absolute_path($main_conf_file)
    validate_absolute_path($galera_conf_file)
    validate_hash($mysql_conf_options)

    validate_hash($galera_conf_options)
    validate_array($nodes)

    # Merge the hash from params.pp, the hash in class parameter and the hash
    # with the wresp address into $_galera_conf_options

    $_galera_conf_options_wo_addr = deep_merge($::mariadb::params::galera_conf_options,
                                               $galera_conf_options)

    # build a small temporary hash to add the wresp cluster address in
    # $_galera_conf_options hash.
    $_galera_conf_options_addr = {
        mysqld => {
          wsrep_cluster_address => sprintf( '"gcomm://%s"', join($nodes, ','))
        }
    }

    $_galera_conf_options = deep_merge($_galera_conf_options_wo_addr,
                                       $_galera_conf_options_addr)
  }

  if $service_manage {
    validate_bool($service_enable)
    validate_string($service_name)
    validate_string($service_ensure)
  }

  anchor { 'mariadb::begin': } ->
  class { '::mariadb::install': } ->
  class { '::mariadb::config': } ->
  class { '::mariadb::service': } ->
  anchor { 'mariadb::end': }
}
