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

class shorewall (
  $serv          = $::shorewall::params::serv,
  $serv_ensure   = $::shorewall::params::serv_ensure,
  $serv_enable   = $::shorewall::params::serv_enable,
  $pkgs          = $::shorewall::params::pkgs,
  $pkgs_ensure   = $::shorewall::params::pkgs_ensure,
  $ip_forwarding = $::shorewall::params::ip_forwarding,
) inherits shorewall::params {

  anchor { 'shorewall::begin': } ->
  class { '::shorewall::install': } ->
  class { '::shorewall::config': } ->
  class { '::shorewall::service': } ->
  anchor { 'shorewall::end': }

}
