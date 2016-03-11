##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2015 EDF S.A.                                      #
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

class tftp::params {

#### Module variables

  $pkgs        = ['tftpd-hpa']
  $pkgs_ensure = 'present'
  $cfg         = '/etc/default/tftpd-hpa'
  $serv        = 'tftpd-hpa'

#### Default variables
  $def_cfg_opts = {
    'TFTP_USERNAME' => '"tftp"',
    'TFTP_DIRECTORY'=> '"/srv/tftp"',
    'TFTP_ADDRESS'  => '"0.0.0.0:69"',
    'TFTP_OPTIONS'  => '"--secure --verbose --create"',
  }

}
