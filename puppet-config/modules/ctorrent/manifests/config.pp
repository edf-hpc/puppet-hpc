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

class ctorrent::config inherits ctorrent {

  file { $::ctorrent::default_file :
    ensure  => present,
    content => template('ctorrent/ctorrent_conf.erb'),
    require => Package[$::ctorrent::packages],
    notify  => Service[$::ctorrent::service],
  }

  file { $::ctorrent::init_file :
    ensure  => present,
    source  => 'puppet:///modules/ctorrent/ctorrent.init',
    mode    => '0755',
    require => Package[$::ctorrent::packages],
  }
}
