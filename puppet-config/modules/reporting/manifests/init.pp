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

class reporting ($script_report_users_source, $script_report_orphan_source, $cron_reporting_source, $script_reportrmo_source, $node_cfg) {

   if $hostname == $node_cfg {

        file { [ "/usr/local/sbin/report_users" ] :
                content => hpc_source_file($script_report_users_source),
                mode    => '0750',
          }

          file { [ "/usr/local/sbin/report_orphan_directory" ] :
                content => hpc_source_file($script_report_orphan_source),
                mode    => '0750',
          }

          file { [ "/etc/cron.d/cron_reporting" ] :
                content => hpc_source_file($cron_reporting_source),
          }

          file { [ "/usr/local/sbin/reportrmo" ] :
    content => hpc_source_file($script_reportrmo_source),
    mode    => '0750',
          }
    }

}

