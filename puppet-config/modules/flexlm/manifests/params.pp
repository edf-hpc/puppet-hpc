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

class flexlm::params {

  #### Module variables
  $service_ensure = 'running'
  $service_enable = true

  #### Defaults values
  $binary_path     = '/usr/local/bin/lmgrd'
  $vendor_name     = ''
  $user            = 'flexlm'
  $user_home       = "/home/${user}"
  $logfile         = "/var/log/flexlm_${vendor_name}"
  $systemd_service = 'flexlm'
  $license_path    = '/etc/flexlm.lic'
  $systemd_config  = {
    'Unit'    => {
      'Description'   => "FlexLM server for ${vendor_name} products",
      'Documentation' => "file:/opt/${vendor_name}/flexlm/README",
      'After'         => 'remote-fs.target network.target home.mount',
    },
    'Service' => {
      'Type'      => 'forking',
      'ExecStart' => "${binary_path} -c ${license_path} -l ${logfile}",
      'User'      => $user,
    },
    'Install' => {
      'WantedBy' => 'multi-user.target',
    },
  }
}
