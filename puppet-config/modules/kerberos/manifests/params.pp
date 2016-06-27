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

class kerberos::params {

  #### Module variables
  $packages_ensure = 'latest'
  $config_dir      = '/etc'
  $config_file     = 'krb5.conf'
  $keytab_file     = 'krb5.keytab'
  case $::osfamily {
    'Debian' : {
      $packages = ['krb5-user','krb5-config']
    }
    'RedHat' : {
      $packages = ['kerberos', 'kerberos-client']
    }
    default : {
      $packages = ['krb5-user','krb5-config']
    }
  }

  #### Defaults values
  $keytab_source  = 'puppet:///modules/kerberos/'
  $decrypt_passwd = 'password'
}
