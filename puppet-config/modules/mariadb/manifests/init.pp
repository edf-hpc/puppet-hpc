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
# @param enable_ssl Boolean to control if SSL is enable on both client and
#            server (default: false)
# @param ssl_ca_file Absolute path to the PEM file containing list of trusted
#            TLS certificate authoritiesL certificate (default:
#            '/etc/ssl/certs/ca-certificates.crt')
# @param ssl_cert_file Absolute path to the SSL certificate (default:
#            '/etc/mysql/ssl/server.pem')
# @param ssl_key_src URL to the SSL private key (default: undef)
# @param ssl_cert_src  URL to the SSL certificate (default: undef)
# @param ssl_key_file Absolute path to SSL private key (default:
#            '/etc/mysql/ssl/server.key')
# @param log_to_rsyslog Boolean to control if MariaDB logs are forwarded to
#            rsyslog (default: false)
# @param log_error_file Absolute path to MariaDB error log file (default:
#            '/var/log/mysql/error.log')
# @param log_info_file Absolute path to MariaDB main log file (default:
#            '/var/log/mysql/mysql.log')
# @param log_slow_file Absolute path to MariaDB slow queries log file (default:
#            '/var/log/mysql/mariadb-slow.log')
# @param log_slow_legacy_file Absolute path to MariaDB legacy slow queries log
#             file (default: '/var/log/mysql/mysql-slow.log')
# @param install_manage Puppet module manages the installation (default: true)
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
# @param decrypt_passwd Encryption key used to decrypt SSL private key (default:
#            undef)
class mariadb (
  $config_manage         = $::mariadb::params::config_manage,
  $galera_conf_file      = $::mariadb::params::galera_conf_file,
  $galera_conf_options   = {},
  $enable_ssl            = $::mariadb::params::enable_ssl,
  $ssl_ca_file           = $::mariadb::params::ssl_ca_file,
  $ssl_cert_file         = $::mariadb::params::ssl_cert_file,
  $ssl_cert_src          = $::mariadb::params::ssl_cert_src,
  $ssl_key_file          = $::mariadb::params::ssl_key_file,
  $ssl_key_src           = $::mariadb::params::ssl_key_src,
  $log_to_rsyslog        = $::mariadb::params::log_to_rsyslog,
  $log_error_file        = $::mariadb::params::log_error_file,
  $log_info_file         = $::mariadb::params::log_info_file,
  $log_slow_file         = $::mariadb::params::log_slow_file,
  $log_slow_legacy_file  = $::mariadb::params::log_slow_legacy_file,
  $install_manage        = $::mariadb::params::install_manage,
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
  $decrypt_passwd        = $::mariadb::params::decrypt_passwd,
) inherits mariadb::params {

  ### Validate params ###
  validate_bool($install_manage)
  validate_bool($config_manage)
  validate_bool($service_manage)

  if $install_manage {
    validate_bool($package_manage)
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
  }

  if $config_manage {
    validate_absolute_path($galera_conf_file)
    validate_hash($galera_conf_options)
    validate_array($nodes)
    validate_bool($enable_ssl)

    # Merge the hash from params.pp, the hash in class parameter and the hash
    # with the wresp address into $_galera_conf_options

    # build a small temporary hash to add the wresp cluster address in
    # $_galera_conf_options hash.
    $_galera_conf_options_addr = {
        mysqld => {
          wsrep_cluster_address => sprintf( '"gcomm://%s"', join($nodes, ','))
        }
    }

    if $enable_ssl {
      validate_absolute_path($ssl_cert_file)
      validate_string($ssl_cert_src)
      validate_absolute_path($ssl_key_file)
      validate_string($ssl_key_src)
      validate_string($decrypt_password)

      $_mariadb_ssl_conf = {
          mysqld => {
            ssl-ca   => $ssl_ca_file,
            ssl-cert => $ssl_cert_file,
            ssl-key  => $ssl_key_file,
          },
          client => {
            ssl                    => 'on',
            ssl-verify-server-cert => 'on',
          },
       }
    } else {
      $_mariadb_ssl_conf = {}
    }

    $_galera_conf_options = deep_merge(
      $::mariadb::params::galera_conf_options,
      $_galera_conf_options_addr,
      $_mariadb_ssl_conf,
      $galera_conf_options
    )

    validate_bool($log_to_rsyslog)
    validate_absolute_path($log_error_file)
    validate_absolute_path($log_info_file)
    validate_absolute_path($log_slow_file)
    validate_absolute_path($log_slow_legacy_file)

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
