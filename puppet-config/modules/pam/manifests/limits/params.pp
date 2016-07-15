##########################################################################
#  Puppet paramsuration file                                             #
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

class pam::limits::params {
  # Common
  $config_file    = '/etc/security/limits.d/puppet.conf'
  $config_options = {}

  # For Debian
  $pam_service = 'common-session'
  $module      = 'pam_access.so'
  $type        = 'session'
  $control     = 'required'
  $position    = 'after #comment[ . = "end of pam-auth-update config" ]'

}
