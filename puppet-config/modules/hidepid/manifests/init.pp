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

class hidepid (
  $hidepid              = $hidepid::params::hidepid,
  $gid                  = $hidepid::params::gid,
  $service              = $hidepid::params::service,
  $systemd_service_file = $hidepid::params::systemd_service_file,
) inherits hidepid::params {

  validate_string($hidepid)
  validate_string($gid)

  # Define the proper options
  if $gid == '' {
    $options = "hidepid=${hidepid}"
  } else {
    $options = "hidepid=${hidepid},gid=${gid}"
  }
  $command  = "/bin/mount -o remount,${options} /proc"
  $systemd_service_file_options = {
    'Unit'    => {
      'Description' => 'Remount proc with hidepid option',
      'After'       => 'sssd.service',
    },
    'Service' => {
      'Type'        => 'oneshot',
      'ExecStart'   => $command,
    },
    'Install' => {
      'WantedBy'    => 'multi-user.target',
    },
  }

  anchor { 'hidepid::begin':} ->
  class { '::hidepid::install': } ->
  class { '::hidepid::service': } ->
  anchor { 'hidepid::end': }

}
