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

class icinga2::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['icinga2',
                      'monitoring-plugins-basic',
                      'monitoring-plugins-hpc-agent']
  $packages_ensure = 'latest'
  $services_manage = true
  $services        = ['icinga2']
  $services_ensure = 'running'
  $services_enable = true
  $config_manage   = true
  $config_dir      = '/etc/icinga2'
  $user            = 'nagios'

  $crt_host        = "${config_dir}/pki/${fqdn}.crt"
  $key_host        = "${config_dir}/pki/${fqdn}.key"
  $crt_ca          = "${config_dir}/pki/ca.crt"

  $local_defs = [ "${config_dir}/conf.d/hosts",
                  "${config_dir}/conf.d/hosts.conf",
                  "${config_dir}/conf.d/services.conf" ]
  $local_defs_ensure = 'absent'

  $zones_file      = "${config_dir}/zones.conf"
  $zones           = {}
  $endpoints       = {}

  $features            = [ 'api' ]
  $feature_enable_cmd  = '/usr/sbin/icinga2 feature enable'
  $features_avail_dir  = "${config_dir}/features-available/"
  $features_enable_dir = "${config_dir}/features-enabled/"

  # features specific params
  $features_conf = {
    'api' => {
      'allow_commands' => false,
      'allow_config'   => false,
    }
  }

  $ident_dir = '/var/lib/icinga2/idents'
  $idents    = {}

  # There is not any sane and secure possible default values for the following
  # params so it is better to not define them in this class.
  #   $crt_host_src
  #   $key_host_src
  #   $crt_ca_src
  #   $decrypt_passwd
}
