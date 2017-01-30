##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2017 EDF S.A.                                      #
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


# Installs basic pam modules packages
#
# PAM (Pluggable Authentication Modules) is used by the system to
# authorize and setup user sessions.
#
# @param packages_ensure  Ensures the packages are in this state (default:
#                         'present)
# @param packages         List of packages to install
class pam (
  $packages                  = $pam::params::packages,
  $packages_ensure           = $pam::params::packages_ensure,
) inherits pam::params {

  validate_array($packages)
  validate_string($packages_ensure)

  class { '::pam::install': }

}
