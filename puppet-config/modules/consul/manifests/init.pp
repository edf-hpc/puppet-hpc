##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class consul (
  $packages         = $::consul::params::packages,
  $packages_ensure  = $::consul::params::packages_ensure,
  $packages_manage  = $::consul::params::packages_manage,
  $services         = $::consul::params::services,
  $services_ensure  = $::consul::params::services_ensure,
  $services_enable  = $::consul::params::services_enable,
  $services_manage  = $::consul::params::services_manage,
  $config_manage    = $::consul::params::config_manage,
  $system_user      = $::consul::params::system_user,
  $conf_dir         = $::consul::params::conf_dir,
  $data_dir         = $::consul::params::data_dir,
  $mode             = $::consul::params::mode,
  $domain           = $::consul::params::domain,
  $datacenter       = $::consul::params::datacenter,
  $binding          = $::consul::params::binding,
  $subservices      = $::consul::params::subservices,
  $nodes            = $::consul::params::nodes,
  $bootstrap        = $::consul::params::bootstrap,
  $key,
) inherits consul::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_bool($packages_manage)
  validate_array($services)
  validate_string($services_ensure)
  validate_bool($services_manage)
  validate_bool($services_enable)
  validate_bool($config_manage)
  validate_string($system_user)
  validate_absolute_path($conf_dir)
  validate_absolute_path($data_dir)
  validate_string($mode)
  validate_string($domain)
  validate_string($datacenter)
  validate_ip_address($binding)
  if $subservices != undef {
      # Subservices can eventually be undefined if there is no subservices to
      # configure of the host. If defined, it must be an array of subservices
      # definitions.
      validate_array($subservices)
  }
  validate_array($nodes)
  validate_string($key)

  if $mode == 'server' {
    # The bootstrap is only used in server mode, then it is irrelevant to
    # validate its value in the other modes.
    validate_integer($bootstrap)
  }

  anchor { 'consul::begin': } ->
  class { '::consul::install': } ->
  class { '::consul::config': } ->
  class { '::consul::service': } ->
  anchor { 'consul::end': }

}
