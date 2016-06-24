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

class proftpd::params {
  $service = 'proftpd'
  $service_ensure = running
  $service_enable = true

  # Set up a cron to automatically stop the service periodically
  # used to allow the service to be started manually and stop it
  # even if the operator forget to do it
  $auto_stop      = false
  $auto_stop_hour = '21'
  $auto_stop_min  = '05'

  $packages = [
    'proftpd-basic'
  ]
  $packages_ensure = 'installed'

  $user_name    = 'ftp'
  $user_home    = '/srv/ftp'
  $user_comment = 'User for FTP server'


  $config_file = '/etc/proftpd/proftpd.conf'

}

