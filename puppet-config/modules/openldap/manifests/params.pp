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

class openldap::params {

#### Module variables

  $packages_ensure            = 'present'
  $packages                   = ['slapd', 'ldapscripts', 'ldap-utils']
  $preseedir                  = '/var/cache/debconf'
  $preseedfile                = "${preseedir}/slapd.preseed"
  $default_file               = '/etc/default/slapd'
  $service                    = 'slapd'
  $make_replica_script        = '/usr/local/sbin/make_ldap_replica.sh'
  $make_replica_script_source = 'puppet:///modules/openldap/make_ldap_replica.sh'

#### Defaults values

  $default_options = {
    'SLAPD_USER'          => '"openldap"',
    'SLAPD_GROUP'         => '"openldap"',
    'SLAPD_SERVICES'      => '"ldapi:/// ldaps://"',
    'SLAPD_SENTINEL_FILE' => '"/etc/ldap/noslapd"',
  }

  $ldif_directory   = '/tmp'
  $directory_source = 'puppet:///modules/openldap'
  $decrypt_passwd   = 'password'
}
