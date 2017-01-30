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

class reporting::config inherits reporting {

  $_template_reporting_users = 'reporting/report_users.erb'
  $_template_cron_reporting = 'reporting/cron_report_users.erb'

  file { $script_report_users :
    content => template($_template_reporting_users),
    mode    => '0750',
  }

  file { $cron_reporting :
    content => template($_template_cron_reporting),
  }

}
