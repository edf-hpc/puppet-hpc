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

# Installs and configure a ProFTPd server
#
# @param service Service name
# @param service_ensure Target state of the service (default: 'running')
# @param service_enable Boolean: is the service starting at boot (default:
#          true)
# @param packages Array of package names
# @param packages_ensure Target state of the packages (default: 'installed')
# @param config_file Absolute path of the configuration file (default:
#          '/etc/proftpd/proftpd.conf')
# @param user_name Name of the FTP user (default: 'ftp')
# @param user_home Absolute path of the FTP user home (default: '/srv/ftp')
# @param user_comment Comment for the FTP user
# @param auto_stop Boolean: the service automatically stop at a fixed time
# @param auto_stop_hour Hour of the time when the service should be stopped
# @param auto_stop_min Minutes of the time when the service should be stopped
class proftpd (
  $service         = $::proftpd::params::service,
  $service_ensure  = $::proftpd::params::service_ensure,
  $service_enable  = $::proftpd::params::service_enable,
  $packages        = $::proftpd::params::packages,
  $packages_ensure = $::proftpd::params::packages_ensure,
  $config_file     = $::proftpd::params::config_file,
  $user_name       = $::proftpd::params::user_name,
  $user_home       = $::proftpd::params::user_home,
  $user_comment    = $::proftpd::params::user_comment,
  $auto_stop       = $::proftpd::params::auto_stop,
  $auto_stop_hour  = $::proftpd::params::auto_stop_hour,
  $auto_stop_min   = $::proftpd::params::auto_stop_min,
) inherits proftpd::params {
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_string($user_name)
  validate_absolute_path($user_home)
  validate_string($user_comment)
  validate_bool($auto_stop)
  validate_string($auto_stop_hour)
  validate_string($auto_stop_min)


  anchor { 'proftpd::begin': } ->
  class { '::proftpd::install': } ->
  class { '::proftpd::config': } ->
  class { '::proftpd::service': } ->
  anchor { 'proftpd::end': }

}
