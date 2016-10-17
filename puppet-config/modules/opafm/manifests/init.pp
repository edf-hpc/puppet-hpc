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

# Installs and configure an Intel OmniPath Fabric Manager
#
# This class sets-up a default config file with some tweakable
# parameters. If the file must be different, it can be provided whole
# as an hpc_file source parameter.
#
# Fabric Executive (FE) is used by FM-GUI to connect to the Fabric Manager
#
#
# @param fe_enable      Enables FE (default: true)
# @param fe_sslsecurity FE uses TLS/SSL connections (default: false)
# @param config_source  Source for a full config file, if not provided
#                       a default template will be used. If provided,
#                       `fe_enable` and `fe_sslsecurity` are ignored.
class opafm (
  $packages        = $::opafm::params::packages,
  $packages_ensure = $::opafm::params::packages_ensure,
  $service         = $::opafm::params::service,
  $service_ensure  = $::opafm::params::service_ensure,
  $service_enable  = $::opafm::params::service_enable,
  $config_file     = $::opafm::params::config_file,
  $config_source   = $::opafm::params::config_hpc_source,
  $fe_enable       = $::opafm::params::fe_enable,
  $fe_sslsecurity  = $::opafm::params::fe_sslsecurity,
) inherits opafm::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_absolute_path($config_file)
  validate_string($config_source)
  validate_bool($fe_enable)
  validate_bool($fe_sslsecurity)
  

  anchor { 'opafm::begin': } ->
  class { '::opafm::install': } ->
  class { '::opafm::config': } ~>
  class { '::opafm::service': } ->
  anchor { 'opafm::end': }
}
