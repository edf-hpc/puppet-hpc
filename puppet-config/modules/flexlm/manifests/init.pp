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

# Set up a flexlm license manager for a specific vendor
#
# @param license_path     Absolute path of the license file
# @param license_path_src Source of the encrypted license file (decrypt)
# @param packages         Array of packages for the license server
# @param decrypt_password Password to use to decrypt `license_path_src`
# @param service_ensure   State of the service : `running` or `stopped`
#                         (default: running)
# @param service_enable   Whether the service should be enabled to start
#                         at boot : `true`, `false`, `manual` or `mask`
#                         (default: true)

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

  $license_dir = dirname($license_path)

  exec { "Create ${license_dir}":
    creates => $license_dir,
    command => "mkdir -p ${license_dir}",
    path    => $::path,
  } -> file { $license_dir : }

  file { $license_path :
    content => decrypt($license_path_src, $decrypt_passwd),
    require => File[$license_dir],
  }

  package { $packages :
    ensure => installed
  }

  service { $::flexlm::params::service_name :
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => [File[$license_path],Package[$packages]],
  }

}
