##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class icinga2::install inherits icinga2 {

  if $::icinga2::install_manage {

    if $::icinga2::packages_manage {
      package { $::icinga2::packages:
        ensure => $::icinga2::packages_ensure,
      }
    }

    # certificate are usefull only if api feature is enable in conf
    if $::icinga2::config_manage and member($::icinga2::features, 'api') {

      file { $::icinga2::key_host :
        ensure  => 'present',
        owner   => $::icinga2::user,
        group   => $::icinga2::user,
        mode    => '0400',
        content => decrypt(
                     $::icinga2::key_host_src,
                     $::icinga2::decrypt_passwd
                   ),
      }

      file { $::icinga2::crt_host:
        content => hpc_source_file($::icinga2::crt_host_src),
        owner   => $::icinga2::user,
        group   => $::icinga2::user,
        mode    => '0644',
      }

      file { $::icinga2::crt_ca:
        content => hpc_source_file($::icinga2::crt_ca_src),
        owner   => $::icinga2::user,
        group   => $::icinga2::user,
        mode    => '0644',
      }

    }
  }
}
