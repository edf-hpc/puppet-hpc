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

class kerberos (
  $packages         = $kerberos::params::packages,
  $packages_ensure  = $kerberos::params::packages_ensure,
  $config_dir       = $kerberos::params::config_dir,
  $config_file      = $kerberos::params::config_file,
  $keytab_file      = $kerberos::params::keytab_file,
  $directory_source = $kerberos::params::keytab_source,
  $decrypt_passwd   = $kerberos::params::decrypt_passwd,
  $config_options,
) inherits kerberos::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_dir)
  validate_string($config_file)
  validate_hash($config_options)
  validate_string($keytab_file)
  validate_string($directory_source)

  anchor { 'kerberos::begin': } ->
  class { '::kerberos::install': } ->
  class { '::kerberos::config': } ->
  anchor { 'kerberos::end': }

}
