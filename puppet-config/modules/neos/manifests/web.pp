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

class neos::web (
  $apache_file      = $::neos::params::web_apache_file,
  $paraview_content = undef,
  $paraview_source  = undef,
  $web_dir          = $::neos::params::web_dir,
) inherits neos::params {
  include ::apache

  ## construct the server.pvsc (Paraview)
  file { $::neos::params::web_dir:
    ensure => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  # Extract some variables to use them in the template
  $cluster_name  = $::neos::_config_options['cluster']
  $partitions    = $::neos::_config_options['partitions']
  $paraview_path = $::neos::_config_options['paraview_path']

  if $paraview_source {
    $_paraview_content = undef
  } else {
    if $paraview_content {
      $_paraview_content = $paraview_content
    } else {
      $_paraview_content = template('neos/web_paraview_server.pvsc.erb')
    }
  }

  file { "${::neos::params::web_dir}/server.pvsc":
    ensure  => present,
    source  => $paraview_source,
    content => $_paraview_content,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
 
  ## Setup the apache configuration
  include ::apache
  file { $apache_file:
    ensure  => present,
    content => template('neos/web_apache.conf.erb'),
    notify  => Class['apache::service'],
  }
 
}
