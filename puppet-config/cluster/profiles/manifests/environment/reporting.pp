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

class profiles::environment::reporting {

   $script_report_users_source = hiera('profiles::environment::reporting::script_report_users_source')
   $script_report_orphan_source = hiera('profiles::environment::reporting::script_report_orphan_source')
   $cron_reporting_source = hiera('profiles::environment::reporting::cron_reporting_source')
   $script_reportrmo_source = hiera('profiles::environment::reporting::script_reportrmo_source')
   $node_cfg = hiera('profiles::environment::reporting::node_cfg')

  class { '::reporting' :
        script_report_users_source => $script_report_users_source,
        script_report_orphan_source => $script_report_orphan_source,
        cron_reporting_source => $cron_reporting_source,
	script_reportrmo_source => $script_reportrmo_source,
        node_cfg => $node_cfg,
  }

}

