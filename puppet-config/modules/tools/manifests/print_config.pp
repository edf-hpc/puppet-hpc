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

define tools::print_config(
  $style,
  $params,
  $target     = $title,
  $separator  = '=',
  $comments   = '#',
  $mode       = '0644'
) {

  case $style {
    ini : {
      $conf_template = 'tools/conf_ini.erb'
    }
    ini_flat : { # No sections.
      $conf_template = 'tools/conf_ini_flat.erb'
    }
    keyval : {
      $conf_template = 'tools/conf_keyval.erb'
    }
    default : {
      $conf_template = ''
    }
  }

  file { $target :
    content => template($conf_template),
    mode    => $mode,
  }

}
