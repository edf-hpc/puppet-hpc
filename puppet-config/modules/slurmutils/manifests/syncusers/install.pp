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

class slurmutils::syncusers::install inherits slurmutils::syncusers {

  if $::slurmutils::syncusers::install_manage {

    if $::slurmutils::syncusers::packages_manage {
      package { $::slurmutils::syncusers::packages:
        ensure => $::slurmutils::syncusers::package_ensure,
      }
    }
    # The sync package already provides a crontab in /etc. Unfortunately, the
    # puppet crontab provider does not support modifying those files. It can
    # only associate cronjobs to users' crontabs. Since we cant to control
    # this cronjob from puppet, the cronjob is defined in root's crontab (by
    # default, as defined in dbd/params.pp) and we ensure the crontab
    # provided by the package is removed (by default) to avoid conflict. This
    # could be easily improved using this external module for eg.:
    #   https://forge.puppet.com/rmueller/cron
    # Check out this issue for reference:
    #   https://github.com/edf-hpc/puppet-hpc/issues/68

    file { $::slurmutils::syncusers::pkg_cron_file:
      ensure => $::slurmutils::syncusers::pkg_cron_ensure,
    }

  }

}
