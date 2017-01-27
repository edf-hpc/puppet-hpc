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

# Allinea Licensing server
#
# If ``lic_enc`` is ``undef``, the license file itself is not handled.
#
# @param packages Array of package names
# @param packages_ensure Target state for packages (default: 'installed')
# @param service_name Service name
# @param service_ensure Target state for the service (default: 'running')
# @param service_enable Service should start on boot (default: true)
# @param lic_file Path of the main allinea::licensing config file
# @param lic_enc Source location of the encrypted license file (default: undef)
# @param decrypt_passwd Password used to decrypt the license file
class allinea::licensing (
  $packages        = $::allinea::licensing::params::packages,
  $packages_ensure = $::allinea::licensing::params::packages_ensure,
  $service_name    = $::allinea::licensing::params::service_name,
  $service_ensure  = $::allinea::licensing::params::service_ensure,
  $service_enable  = $::allinea::licensing::params::service_enable,
  $lic_file        = $::allinea::licensing::params::lic_file,
  $lic_enc         = $::allinea::licensing::params::lic_enc,
  $decrypt_passwd  = $::allinea::licensing::params::decrypt_passwd,
) inherits allinea::licensing::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service_name)
  validate_string($service_ensure)
  validate_bool($service_enable)
  if $lic_enc {
    validate_string($lic_enc)
    validate_string($decrypt_passwd)
  }

  anchor { 'allinea::licensing::begin': } ->
  class { '::allinea::licensing::install': } ->
  class { '::allinea::licensing::config': } ~>
  class { '::allinea::licensing::service': } ->
  anchor { 'allinea::licensing::end': }
}
