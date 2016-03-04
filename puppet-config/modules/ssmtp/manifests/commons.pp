##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2015 EDF S.A.                                      #
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

class ssmtp::commons (
  $pkgs                = $ssmtp::params::pkgs,
  $cfg                 = $ssmtp::params::cfg,
  $cfg_opts            = $ssmtp::params::cfg_opts,
) inherits ssmtp::params {

  $main_config = merge($cfg_opts,$profile_opts)

  package { $pkgs :}

  tools::print_config { $cfg :
    style   => 'keyval',
    params  => $main_config,
    require => Package[$pkgs]
  }

}
