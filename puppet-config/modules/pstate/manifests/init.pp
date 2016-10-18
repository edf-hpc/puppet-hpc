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

# Configure Intel pstate at node boot
#
# This just sets a script (/usr/local/sbin/pstate_set.sh) and launch it
# during boot with a systemd unit
class pstate (
  $script_file                  = $pstate::params::script_file,
  $systemd_service_file         = $pstate::params::systemd_service_file,
  $systemd_service_file_options = $pstate::params::systemd_service_file_options,
) inherits pstate::params {

  validate_absolute_path($script_file)
  validate_absolute_path($systemd_service_file)
  validate_hash($systemd_service_file_options)

  anchor { 'pstate::begin': } ->
  class { '::pstate::install': } ~>
  class { '::pstate::service': } ->
  anchor { 'pstate::end': }

}
