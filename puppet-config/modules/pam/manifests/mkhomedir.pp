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

# Configure pam_python with a mk_homedir.py script: Automatically creates
# /home and /scratch directories upon login.
#
# Only works on Debian
#
# @param packages_ensure  Ensures the packages are in this state (default:
#                         'present)
# @param packages         List of packages to install
# @param config_file      Configuration filename for the Python PAM module
#                         script (default: /etc/pam_mkhomedir.ini)
# @param config_options   Content of config_file
#
class pam::mkhomedir (
  $packages_ensure  = $::pam::mkhomedir::params::packages_ensure,
  $packages         = $::pam::mkhomedir::params::packages,
  $config_file      = $::pam::mkhomedir::params::config_file,
  $config_options   = $::pam::mkhomedir::params::config_options
) inherits pam::mkhomedir::params {
  require ::pam

  validate_string($packages_ensure)
  validate_array($packages)
  validate_absolute_path($config_file)
  validate_hash($config_options)

  anchor { 'pam::mkhomedir::begin': } ->
  class { '::pam::mkhomedir::install': } ->
  class { '::pam::mkhomedir::config': } ->
  anchor { 'pam::mkhomedir::end': }

}
