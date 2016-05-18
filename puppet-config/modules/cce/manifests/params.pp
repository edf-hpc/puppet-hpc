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

class cce::params {

#### Module variables

  $packages_ensure = 'latest'
  $packages        = ['cce-command-suite']
  $default_file    = '/etc/default/cce.conf'

#### Defaults values
  $default_options = {
    pathbatch           => '/usr/bin',
    typenni             => 'toupper',
    qoshidden           => 'none',
    parthidden          => 'none',
    typecluster         => 'normal',
    cce_mpp_mod         => 'on',
    cce_mpinfo_mod      => 'on',
    cce_mqinfo_mod      => 'on',
    cce_mpp_mod         => 'on',
    cce_myaccount_mod   => 'off',
    cce_quota_mod       => 'off',
    cce_quota_info      => '',
    cce_quota_listvol   => '',
    cce_user_mod        => 'off'
  }


}
