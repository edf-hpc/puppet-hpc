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

class ceph (
  $packages        = $::ceph::params::packages,
  $packages_ensure = $::ceph::params::packages_ensure,
  $services        = $::ceph::params::services,
  $service_ensure  = $::ceph::params::service_ensure,
  $service_enable  = $::ceph::params::service_enable,
  $config_file     = $::ceph::params::config_file,
  $config_options  = {},
  $keyrings        = {},
  $ceph_cluster_name = $::ceph::params::ceph_cluster_name,
  $osd_path        = $::ceph::params::osd_path,
  $osd_config      = {},
) inherits ceph::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_hash($keyrings)
  validate_string($ceph_cluster_name)
  validate_string($osd_path)
  validate_hash($osd_config)

  $_config_options = merge ($::ceph::params::config_options_defaults, $config_options)

  anchor { 'ceph::begin': } ->
  class { '::ceph::install': } ->
  class { '::ceph::config': } ->
  class { '::ceph::service': } ->
  anchor { 'ceph::end': }
}
