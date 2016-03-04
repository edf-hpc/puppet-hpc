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

define tools::systemd_service($target,$config) {

  $servname  = inline_template('<%= File.basename(@target) %>')

  file { $target :
    content    => template('tools/systemd_service.erb'),
  }

  ### Systemctl execution on supported environments ###
  case $::osfamily {
    'Debian' : {
      case $::puppet_context {
        'ondisk', 'diskless-postinit': {
          exec { $target :
            command => "/bin/systemctl daemon-reload && /bin/systemctl enable ${servname}",
            require => File[$target],
          }
        }
        default: {}
      }
    }
    'Redhat' : {
      case $::puppet_context {
        'ondisk': {
          exec { $target :
            command => "systemctl daemon-reload && systemctl enable ${servname}",
            require => File[$target],
          }
        }
        default: {}
      }
    }
    default: {}
  }
}

