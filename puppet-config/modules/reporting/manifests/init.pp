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

class reporting (
  $script_report_users = $reporting::params::script_report_users,
  $cron_reporting      = $reporting::params::cron_reporting,
  $config_report_users   = {},
) inherits reporting::params {

  validate_absolute_path($script_report_users)
  validate_absolute_path($cron_reporting)
  validate_hash($config_report_users)

  $_config_options=deep_merge($reporting::params::config_options_defaults, $config_report_users)

  anchor { 'reporting::begin': } ->
  class { '::reporting::config': } ->
  anchor { 'reporting::end': }

}