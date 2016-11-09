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
class flexlm (
  $license_path     = $::flexlm::params::license_path,
  $license_path_src = '',
  $decrypt_passwd   = 'passw0rd',
  $packages         = $::flexlm::params::packages,
  $service_ensure   = $::flexlm::params::service_ensure,
  $service_enable   = $::flexlm::params::service_enable,
) inherits flexlm::params {

  validate_absolute_path($license_path)
  validate_string($license_path_src)
  validate_array($packages)
  validate_string($service_ensure)
  validate_bool($service_enable)

  file { $license_path :
    content  => decrypt($license_path_src, $decrypt_passwd)
  }

  service { $service_name :
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => File[$license_path],
  }

}
