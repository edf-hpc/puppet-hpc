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

# This class uses the augeasproviders_pam::pam type
class pam::limits (
  $pam_service = $pam::params::limits_pam_service,
  $module      = $pam::params::limits_module,
  $control     = $pam::params::limits_control,
  $type        = $pam::params::limits_type,
  $position    = $pam::params::limits_position,
  $rules_file  = $pam::params::limits_rules_file,
  $rules       = {},
) inherits pam::params {

  validate_string($pam_service)
  validate_string($module)
  validate_string($type)
  validate_string($control)
  validate_string($position)
  validate_hash($rules)


  pam { 'Resources limits':
    ensure   => present,
    provider => augeas,
    service  => $pam_service,
    type     => $type,
    module   => $module,
    control  => $control,
    position => $position,
  }

  $rules_array = values($rules)
  hpclib::print_config{ $rules_file:
    style => 'linebyline',
    data  => $rules_array,
  }

}
