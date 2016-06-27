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

class pam (
  $packages                  = $pam::params::packages,
  $packages_ensure           = $pam::params::packages_ensure,
  $pam_modules_config_dir    = $pam::params::pam_modules_config_dir,
  $pam_ssh_config            = $pam::params::pam_ssh_config,
) inherits pam::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($pam_modules_config_dir)
  validate_absolute_path($pam_ssh_config)

  class { '::pam::install': }

}
