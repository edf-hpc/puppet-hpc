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

# create a systemd unit file
#
# A unit file is created, loaded in systemd and enabled
#
# ```
# hpclib::systemd_service{ 'foo':
#   target => '/etc/systemd/system/foo.service',
#   config => {
#     'Unit' => {
#       'Description' => 'Fooing',
#     },
#     'Service' => {
#       'Type'      => 'oneshot',
#       'KillMode'  => 'process',
#       'ExecStart' => '/usr/bin/foo',
#     },
#     'Install' => {
#       'WantedBy' => 'multi-user.target',
#     }
#   }
# }
# ```
#
# @param target Absolute path of the unit file
# @param config Hash representing the content of the unit file
#
define hpclib::systemd_service(
  $target,
  $config,
) {

  $service_name = basename($target)

  file { $target :
    content => template('hpclib/systemd_service.erb'),
  }

  ### Systemctl execution on supported environments ###

  exec { $target :
    command     => "/bin/systemctl daemon-reload && /bin/systemctl enable ${service_name}",
    refreshonly => true,
    subscribe   => File[$target],
    require     => File[$target],
  }

}
