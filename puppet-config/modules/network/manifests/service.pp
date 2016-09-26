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

class network::service inherits network {

  if $::network::opa_enable {
    service { $::network::irqbalance_service :
      ensure => $::network::irqbalance_ensure,
      enable => $::network::irqbalance_enable,
    }
  }

  # Install systemd services on supported OS.
  if $::operatingsystem == 'Debian' and $::operatingsystemmajrelease >= '8' {

    hpclib::systemd_tmpfile { $::network::systemd_tmpfile :
      target => $::network::systemd_tmpfile,
      config => $::network::systemd_tmpfile_options,
    }

    hpclib::systemd_service { $::network::ifup_hotplug_service_file :
      target => $::network::ifup_hotplug_service_file,
      config => $::network::ifup_hotplug_service_params,
    }

    # Enable systemd service ifup-hotplug to ensure it is run at server boot.
    # If service provider is systemd (calibre9 running production),
    # use Puppet service type.
    # If service provider is debian (calibre9 during the late_command
    # of debian installer), use Puppet file type since systemd/systemctl is not
    # running at this stage.
    case $::puppet_context {
      'ondisk', 'diskless-postinit': {
        create_resources(service, $::network::ifup_hotplug_services)
      }
      'installer', 'diskless-preinit': {
        create_resources(file, $::network::ifup_hotplug_files)
      }
      default : {
        fail("Unsupported context '${::puppet_context}', should be: 'ondisk', 'diskless-postinit' 'installer', 'diskless-preinit'")
      }
    }
  }
  else {
    notice('Unsupported service provider for class network::service.')
  }

}
