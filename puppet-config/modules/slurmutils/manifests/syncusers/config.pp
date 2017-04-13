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

class slurmutils::syncusers::config inherits slurmutils::syncusers {

  if $::slurmutils::syncusers::config_manage {

    hpclib::print_config { $::slurmutils::syncusers::conf_file:
      style => 'ini',
      data  => $::slurmutils::syncusers::_conf_options,
    }

    cron { 'syncusers':
      command => $::slurmutils::syncusers::cron_exec,
      user    => $::slurmutils::syncusers::cron_user,
      hour    => $::slurmutils::syncusers::cron_hour,
      minute  => $::slurmutils::syncusers::cron_minute,
    }

  }

}
