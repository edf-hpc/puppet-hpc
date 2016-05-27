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

class clustershell::params {
  $packages_ensure = 'installed'
  case $::osfamily {
    'RedHat': {
      $packages = [
        'clustershell',
        'PyYAML',
      ]
    }
    'Debian': {
      $packages = [
        'clustershell',
        'python-yaml',
      ]
    }
  }

  $groups_file = '/etc/clustershell/groups.conf'
  $groups_options_default = {
    'Main' => {
      'default' => 'local',
      'confdir' => '/etc/clustershell/groups.conf.d $CFGDIR/groups.conf.d',
      'autodir' => '/etc/clustershell/groups.d $CFGDIR/groups.d',
    },
    'local' => {
      'map'  => '/etc/clustershell/groups.conf.d $CFGDIR/groups.conf.d',
      'all'  => '[ -f $CFGDIR/groups ] && f=$CFGDIR/groups || f=$CFGDIR/groups.d/local.cfg; sed -n "s/^all:\(.*\)/\1/p" $f',
      'list' => '[ -f $CFGDIR/groups ] && f=$CFGDIR/groups || f=$CFGDIR/groups.d/local.cfg; sed -n "s/^\([0-9A-Za-z_-]*\):.*/\1/p" $f',
    },
  }
  $groups = {}
  $groups_yaml_file = '/etc/clustershell/groups.d/puppet.yaml'
}

