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

class ssmtp (
  $pkgs         = $ssmtp::params::pkgs,
  $pkgs_ensure  = $ssmtp::params::pkgs_ensure,
  $cfg          = $ssmtp::params::cfg,
  $ext_cfg_opts = $ssmtp::params::ext_cfg_opts
) inherits ssmtp::params {

  $def_cfg_opts = $ssmtp::params::def_cfg_opts

  validate_array($pkgs)
  validate_string($pkgs_ensure)
  validate_absolute_path($cfg)
  validate_hash($def_cfg_opts)
  validate_hash($ext_cfg_opts)

}
