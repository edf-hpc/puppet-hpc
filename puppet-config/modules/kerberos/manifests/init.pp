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


# Configure a kerberos client
#
# The encrypted keytab is downloaded from this source location:
# `$keytab_source_dir/$hostname.krb5.keytab.enc`.
#
# @param config_file Path of the main kerberos config (default: '/etc/krb5.conf')
# @param config_options Hash with the content of `config_file`
# @param keytab_file Path of the local system keytab
# @param keytab_source_dir Base location for the keytab source
# @param decrypt_passwd Password to use to decrypt the keytab
# @param packages List of packages to install
# @param packages_ensure Target state of packages. (default: 'latest')
class kerberos (
  $config_options,
  $packages          = $kerberos::params::packages,
  $packages_ensure   = $kerberos::params::packages_ensure,
  $config_file       = $kerberos::params::config_file,
  $keytab_file       = $kerberos::params::keytab_file,
  $keytab_source_dir = $kerberos::params::keytab_source_dir,
  $decrypt_passwd    = $kerberos::params::decrypt_passwd,
) inherits kerberos::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_absolute_path($keytab_file)
  validate_hash($config_options)
  validate_string($keytab_source_dir)

  anchor { 'kerberos::begin': } ->
  class { '::kerberos::install': } ->
  class { '::kerberos::config': } ->
  anchor { 'kerberos::end': }

}
