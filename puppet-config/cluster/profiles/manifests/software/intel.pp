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

# Intel license server
#
# ## Hiera
# * `profiles::software::intel::license_path`
# * `profiles::software::intel::binary_path`
# * `profiles::software::intel::vendor_name`
# * `profiles::software::intel::user_home`
# * `profiles::software::intel::systemd_service`
# * `profiles::software::intel::systemd_config`
class profiles::software::intel {

  ## Hiera lookups
  $license_path    = hiera('profiles::software::intel::license_path')
  $binary_path     = hiera('profiles::software::intel::binary_path')
  $vendor_name     = hiera('profiles::software::intel::vendor_name')
  $user_home       = hiera('profiles::software::intel::user_home')
  $systemd_service = hiera('profiles::software::intel::systemd_service')
  $systemd_config  = hiera('profiles::software::intel::systemd_config') 

  # Pass config options as a class parameter
  include flexlm::params
  flexlm::service { 'intel':
    binary_path     => $binary_path,
    license_path    => $license_path,
    vendor_name     => $vendor_name,
    user_home       => $user_home,
    systemd_config  => $systemd_config,
    systemd_service => $systemd_service,
  }  

}
