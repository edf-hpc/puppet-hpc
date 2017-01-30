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

class nscang::server::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['nsca-ng-server']
  $packages_ensure = 'latest'
  $services_manage = true
  $services        = ['nsca-ng-server']
  $services_ensure = 'running'
  $services_enable = true
  $config_manage   = true
  $config_file     = '/etc/nsca-ng/nsca-ng.local.cfg'
  $user            = 'nagios'
  $identity        = 'agent-checker'
  $cmd_file        = '/var/run/icinga2/cmd/icinga2.cmd'

  # There is not any sane and secure possible default values for the following
  # params so it is better to not define them in this class.
  #   $password
}
