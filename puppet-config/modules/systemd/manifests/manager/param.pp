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

define systemd::manager::param (
  $value,
) {

  # Many augeas commands combinations have been tried before using file_line,
  # without success so far... All parameters are present in system.conf file
  # but commented-out by default. It is apparently hard to instruct augeas to
  # uncomment a parameter and then set its value.
  #
  # First, using those 2 commands:
  #
  #   rename Manager/#comment[. =~ regexp('${name}.*')] ${name}
  #   set Manager/${name} ${value}
  #
  # But unfortunately, puppet 3.7 does not support the augeas rename command.
  #
  # Then, using move instead of rename:
  #
  #   move Manager/#comment[. =~ /${name}.*/)] Manager/${name}
  #   set Manager/${name} ${value}
  #
  # Even though it works under augtool, puppet (or the augeas ruby binding)
  # does support this syntax and raise an error.
  #
  # The other way would be to insert the parameter even though it is present
  # and commented-out but the insert command requires a where clause to specify
  # the position which is not obvious since it depends on the content of the
  # file which is not necessarily known.
  #
  # Last thing, there is a bug in systemd lens, it does include /etc/systemd/*
  # in its filters. The lens/incl augeas resource parameters must be used to
  # force the lens on /etc/systemd/system.conf file.
  #
  # For those reasons, file_line has been adopted as a fallback solution. It
  # works nicely in this file since there is only one section ([Manager]) and
  # the parameters can appear only once.

  file_line { 'systemd-system-manager-${name}':
    ensure => present,
    path   => '/etc/systemd/system.conf',
    line   => "${name}=${value}",
    match  => "^.*${name}.*",
  }

}
