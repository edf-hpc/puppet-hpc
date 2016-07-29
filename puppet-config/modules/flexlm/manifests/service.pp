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

# Set up a flexlm license manager for a specific vendor
# 
# @param license_path     Absolute path of the license file
# @param service_ensure   State of the service : `running` or `stopped` 
#                         (default: running)
# @param service_enable   Whether the service should be enabled to start 
#                         at boot : `true`, `false`, `manual` or `mask`
#                         (default: true)
# @param binary_path      Absolute path of the license manager binary   
# @param vendor_name      Name of the vendor using flexlm 
# @param user             User that runs the flexlm service
# @param user_home        Home of the user that runs the flexlm service
# @param logfile          Absolute path of the flexlm log file 
# @param systemd_service  Absolute path of the flexlm service unit file
# @param systemd_config   Hash that contains the configuration of the flexlm
#                         service unit file          
define flexlm::service (
  $license_path,
  $service_ensure  = $flexlm::params::service_ensure,
  $service_enable  = $flexlm::params::service_enable,
  $binary_path     = $flexlm::params::binary_path,
  $vendor_name     = $flexlm::params::vendor_name,
  $user            = $flexlm::params::user,
  $user_home       = $flexlm::params::user_home,
  $logfile         = $flexlm::params::logfile,
  $systemd_service = $flexlm::params::systemd_service,
  $systemd_config  = $flexlm::params::systemd_config,
) {

  validate_absolute_path($license_path)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_absolute_path($binary_path)
  validate_string($vendor_name)
  validate_string($user)
  validate_absolute_path($user_home)
  validate_absolute_path($logfile)
  validate_string($systemd_service)
  validate_hash($systemd_config)

  hpclib::systemd_service { $systemd_service :
    target  => $systemd_service,
    config  => $systemd_config,
    require => [User[$user],File[$logfile]]
  }

  user { $user :
    ensure => present,
    home   => $user_home,
    system => true,
  }

  file { $logfile :
    ensure => file,
    owner  => $user,
  }

  service { "flexlm_${vendor_name}" :
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => [
      Hpclib::Systemd_service[$systemd_service],
      File[$logfile],
    ],
  }
}
