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

# Setup system wide OpenSSH client options
#
# @param packages Array of package names to install
# @param packages_ensure Target state of the packages (default: 'latest')
# @param config_file Path of the ssh client config file (default:
#          '/etc/ssh/ssh_config)
# @param config_augeas Augeas commands to apply in the config file
# @param augeas_context Default Host augeas Context
class openssh::client (
  $packages         = $::openssh::client::params::packages,
  $packages_ensure  = $::openssh::client::params::packages_ensure,
  $config_file      = $::openssh::client::params::config_file,
  $config_augeas    = $::openssh::client::params::config_augeas,
  $augeas_context   = $::openssh::client::params::augeas_context,
) inherits openssh::client::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_array($config_augeas)
  validate_absolute_path($augeas_context)

  anchor { 'openssh::client::begin': } ->
  class { '::openssh::client::install': } ->
  class { '::openssh::client::config': } ->
  anchor { 'openssh::client::end': }

}
