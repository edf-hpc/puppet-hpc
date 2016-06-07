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

class carboncrelay::config inherits carboncrelay {
  concat { $::carboncrelay::config_file:
    ensure => present,
    notify => Class['::carboncrelay::service'],
  }
  concat::fragment { 'carboncrelay_config_header':
    target  => $::carboncrelay::config_file,
    order   => '01',
    content => template('carboncrelay/config.header.erb'),
  }
  Concat::Fragment <| target == $::carboncrelay::config_file |>

}

