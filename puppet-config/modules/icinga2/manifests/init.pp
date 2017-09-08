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

# Deploys icinga2 satellite and agent
#
# @param install_manage  Public class manages the installation (default: true)
# @param packages_manage Public class installs the packages (default: true)
# @param packages        Array of packages to install (default:
#                        ['icinga2', 'monitoring-plugins-basic',
#                         'monitoring-plugins-hpc-agent'])
# @param packages_ensure Target state for the packages (default: 'latest')
# @param services_manage Public class manages the service state (default: true)
# @param services        Array of services to manage (default: ['icinga2'])
# @param services_ensure Target state for the services (default: 'running')
# @param services_enable The services start at boot time (default: true)
# @param config_manage   Public class manages the configuration (default: true)
# @param user            Name of icinga2 system user (default: 'nagios')
# @param crt_host        Absolute path to host SSL certificate used by the API
#                        listener (default: '/etc/icinga2/pki/${::fqdn}.crt')
# @param key_host        Absolute path to host SSL key used by the API listener
#                        (default: '/etc/icinga2/pki/${::fqdn}.key')
# @param crt_ca          Absolute path to PKI CA SSL certificate used by all API
#                        listeners (default: '/etc/icinga2/pki/ca.crt')
# @param local_defs      Array of absolute paths of configuration files provided
#                        by the package (default: ['/etc/icinga2/conf.d/hosts',
#                        '/etc/icinga2/conf.d/hosts.conf',
#                        '/etc/icinga2/conf.d/services.conf']
# @param local_defs_ensure Target state of the configuration files provided by
#                        the packages (default: 'absent')
# @param zones_file      Absolute path to zones configuration file (default:
#                        '/etc/icinga2/zones.conf')
# @param features        Array of icinga2 features to enable (default: ['api'])
# @param feature_enable_cmd Command to run to enable a feature (default:
#                        '/usr/sbin/icinga2 feature enable')
# @param features_avail_dir Absolute path to directory containing available
#                        features (default: '/etc/icinga2/features-available/')
# @param features_enable_dir Absolute path to directory containing enabled
#                        features (default: '/etc/icinga2/features-enabled/')
# @param features_conf   Hash of additional icinga2 features configuration
#                        parameters (default: {})
# @param ident_dir       Absolute path of directory containing identities files
#                        (passwords, keys) used for monitoring purpose (default:
#                        '/var/lib/icinga2/idents')
# @param idents          Hash of idents definitions (default: {})
# @param bind_host       Host to bind API listener socket, ignored if undef
#                        (default: undef).
# @param crt_host_src    URL to source host SSL certificate (no default)
# @param key_host_src    URL to source host SSL encrypted key (no default)
# @param crt_ca_src      URL to source CA SSL certificate (no default)
# @param decrypt_passd   Encryption key to decrypt SSL key and identies files
#                        (no default)

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
  $bind_host           = $::icinga2::params::bind_host,
  $crt_host_src,
  $key_host_src,
  $crt_ca_src,
  $decrypt_passwd,
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
    validate_string($bind_host)

    if $bind_host {
      $_bind_host_conf = {
        'api' => {
          'bind_host' => $bind_host,
        },
      }
    } else {
      $_bind_host_conf = {}
    }

    $_bind_host_merged_conf = deep_merge( $::icinga2::params::features_conf,
                                          $_bind_host_conf)

    $_features_conf = deep_merge( $_bind_host_merged_conf,
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

  anchor { 'icinga2::begin': } ->
  class { '::icinga2::install': } ->
  class { '::icinga2::config': } ->
  class { '::icinga2::service': } ->
  anchor { 'icinga2::end': }

}
