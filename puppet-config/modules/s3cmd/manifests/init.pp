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

# Setup s3cmd
# @param packages Array of packages to install
# @param packages_ensure Target state of the installed packages (default: present)
# @param config_file Path of the configuration file (default: '/root/.s3cfg')
# @param config_options Hash with the content of `config_file` (merged with defaults)

class s3cmd (
  $packages        = $::s3cmd::params::packages,
  $packages_ensure = $::s3cmd::params::packages_ensure,
  $config_file     = $::s3cmd::params::config_file,
  $config_options  = {},
) inherits s3cmd::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)

  $_config_options=deep_merge($s3cmd::params::config_options_defaults, $config_options)

  anchor { 's3cmd::begin': } ->
  class { '::s3cmd::install': } ->
  class { '::s3cmd::config': } ->
  anchor { 's3cmd::end': }

}
