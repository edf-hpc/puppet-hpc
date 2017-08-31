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

# Installs and ceph
#
# @param packages Array of packages to install (default: ['ceph', 'ceph-deploy',
#            'ceph-mds', 'ceph-mon', 'ceph-osd', 'radosgw'])
# @param package_ensure Target state for the packages (default: 'installed')
# @param ceph_user Name of ceph system user (default: 'ceph')
# @param services Array of services to manage (default: ['ceph'])
# @param service_ensure Target state of services (default: 'running')
# @param service_enable Starts service on boot (default: true)
# @param config_file Absolute path to the main ceph configuration file (default:
#            '/etc/ceph/ceph.conf')
# @param config_options Hash of additional configuration parameters to merge in
#            default configuration (default: {})
# @param keyrings Hash of Ceph cluster keyrings (default: {})
# @param mds_keyrings Hash of Ceph MDS keyrings (default: {})
# @param osd_keyrings Hash of Ceph OSD keyrings (default: {})
# @param rgw_client_keyring Hash of Ceph RadosGW keyrings (default: {})
# @param ceph_cluster_name Name of Ceph cluster (default: 'ceph')
# @param osd_path Path to OSD directory (default: '/var/lib/ceph/osd')
# @param osd_config Hash of configuration parameters of Ceph OSD (default: {})
# @param mon_config Array of configuration parameters of Ceph MON (default: [])
# @param mds_config Array of configuration parameters of Ceph MDS (default: [])
# @param rgw_config Array of configuration parameters of Ceph RadosGW (default:
#            [])
# @param restrict_networks Boolean to control if Ceph daemons listen on a
#            restricted list of IP networks (default: true)
# @param public_network IP network CIDR of Ceph clients (default:
#            '127.0.0.1/32')
# @param cluster_network IP network CIDR used to communicate between Ceph OSD
#            (default: '127.0.0.1/32')
# @param rgw_host IP address used to bind the RadosGW socket (default:
#            '127.0.0.1')
class ceph (
  $packages          = $::ceph::params::packages,
  $packages_ensure    = $::ceph::params::packages_ensure,
  $ceph_user          = $::ceph::params::ceph_user,
  $services           = $::ceph::params::services,
  $service_ensure     = $::ceph::params::service_ensure,
  $service_enable     = $::ceph::params::service_enable,
  $config_file        = $::ceph::params::config_file,
  $config_options     = {},
  $keyrings           = {},
  $mds_keyring        = {},
  $osd_keyring        = {},
  $rgw_client_keyring = {},
  $ceph_cluster_name  = $::ceph::params::ceph_cluster_name,
  $osd_path           = $::ceph::params::osd_path,
  $osd_config         = {},
  $mon_config         = [],
  $mds_config         = [],
  $rgw_config         = [],
  $restrict_networks  = $::ceph::params::restrict_networks,
  $public_network     = $::ceph::params::public_network,
  $cluster_network    = $::ceph::params::cluster_network,
  $rgw_host           = $::ceph::params::rgw_host,
) inherits ceph::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($ceph_user)
  validate_array($services)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_hash($keyrings)
  validate_hash($mds_keyring)
  validate_hash($osd_keyring)
  validate_hash($rgw_client_keyring)
  validate_string($ceph_cluster_name)
  validate_string($osd_path)
  validate_hash($osd_config)
  validate_array($mon_config)
  validate_array($mds_config)
  validate_array($rgw_config)
  validate_bool($restrict_networks)

  if $restrict_networks {
    $_restrict_nets_conf = {
      global => {
        'public network'  => $public_network,
        'cluster network' => $cluster_network,
      },
      "client.rgw.${::hostname}" => {
        # This parameter is not mentioned in Ceph official documentation. It is
        # mentioned in some bug reports or howtos written by the community.
        # Refer to this bug report for this documentation miss:
        #
        #   http://tracker.ceph.com/issues/13670
        #
        # Usually, the parameter is to setup the fastcgi frontend but this one
        # requires a frontend HTTP server such as Apache2. So far, the default
        # built-in civetweb frontend is used on Scibian HPC clusters.
        #
        # After a look at the RadosGW source code, it has been figured out that
        # only the 'port' is accepted for this frontend. The value is then
        # directly transmitted (w/o modification) to the civetweb library
        # through the 'listening_ports' parameter. This parameter is documented
        # in the civetweb user manual available at this URL:
        #
        #   https://github.com/civetweb/civetweb/blob/master/docs/UserManual.md
        #
        'rgw frontends'   => "civetweb port=${rgw_host}:7480",
      },
    }
  } else {
    $_restrict_nets_conf = {}
  }

  $_config_options = deep_merge($::ceph::params::config_options_defaults,
                                $_restrict_nets_conf,
                                $config_options)

  anchor { 'ceph::begin': } ->
  class { '::ceph::install': } ->
  class { '::ceph::config': } ->
  class { '::ceph::service': } ->
  anchor { 'ceph::end': }

  Class['::ceph::config'] -> Ceph::Posix::Mount <||>
}
