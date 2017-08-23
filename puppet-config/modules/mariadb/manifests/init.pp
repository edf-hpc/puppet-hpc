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

# Installs and configure mariadb/galera with clustering
#
# @param config_manage Puppet modules generate configuration (default: true)
# @param galera_conf_file Path of galera configuration file
# @param galera_conf_options Hash with the content of `galera_conf_file` (merged with defaults)
# @param package_manage Puppet module installs the packages (default: true)
# @param package_ensure Target state for the packages (default: 'present')
# @param package_name Array of names of packages to install
# @param disable_histfile Boolean to control whether ~/.mysql_history files are
#            disabled or not (default: true)
# @param prof_histfile_file Absolute path to shell profile for MariaDB used to
#            disable histfile (default:
#            '/etc/profile.d/100-disable_mariadb_histfile.sh').
# @param prof_histfile_options Array of lines of content of shell profile file
#            used to disable histfile (default: [ 'MYSQL_HISTFILE=/dev/null' ])
# @param root_histfile_file Absolute path to root histfile (default:
#            '/root/.mysql_history')
# @param root_histfile_target Target of root histfile symlink when
#            disable_histfile is true (default: '/dev/null')
# @param service_manage Puppet module manages the service state (default: true)
# @param service_ensure Target state for the service (default: 'running')
# @param service_enable Starts service on boot (default: true)
# @param service_name Name of the service for mariadb
# @param nodes Array of host names forming the galera cluster
class mariadb (
  $config_manage         = $::mariadb::params::config_manage,
  $galera_conf_file      = $::mariadb::params::galera_conf_file,
  $galera_conf_options   = {},
  $package_manage        = $::mariadb::params::package_manage,
  $package_ensure        = $::mariadb::params::package_ensure,
  $package_name          = $::mariadb::params::package_name,
  $disable_histfile      = $::mariadb::params::disable_histfile,
  $prof_histfile_file    = $::mariadb::params::prof_histfile_file,
  $prof_histfile_options = $::mariadb::params::prof_histfile_options,
  $root_histfile_file    = $::mariadb::params::root_histfile_file,
  $root_histfile_target  = $::mariadb::params::root_histfile_target,
  $service_manage        = $::mariadb::params::service_manage,
  $service_ensure        = $::mariadb::params::service_ensure,
  $service_enable        = $::mariadb::params::service_enable,
  $service_name          = $::mariadb::params::service_name,
  $nodes                 = $::mariadb::params::nodes,
) inherits mariadb::params {

  ### Validate params ###
  validate_bool($package_manage)
  validate_bool($config_manage)
  validate_bool($service_manage)
  validate_bool($disable_histfile)
  validate_absolute_path($prof_histfile_file)
  validate_absolute_path($root_histfile_file)

  if $package_manage {
    validate_array($package_name)
    validate_string($package_ensure)
  }
  if $disable_histfile {
    validate_array($prof_histfile_options)
    validate_absolute_path($root_histfile_target)
  }

  if $config_manage {
    validate_absolute_path($galera_conf_file)
    validate_hash($galera_conf_options)
    validate_array($nodes)

    # Merge the hash from params.pp, the hash in class parameter and the hash
    # with the wresp address into $_galera_conf_options

    $_galera_conf_options_wo_addr = deep_merge(
      $::mariadb::params::galera_conf_options,
      $galera_conf_options
    )

    # build a small temporary hash to add the wresp cluster address in
    # $_galera_conf_options hash.
    $_galera_conf_options_addr = {
        mysqld => {
          wsrep_cluster_address => sprintf( '"gcomm://%s"', join($nodes, ','))
        }
    }

    $_galera_conf_options = deep_merge(
      $_galera_conf_options_wo_addr,
      $_galera_conf_options_addr
    )
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
