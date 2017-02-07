#!/usr/bin/env ruby
##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2017 EDF S.A.                                           #
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

require('hpc_backup')

# @param arg1 A hash of sources
# @param arg2 A base target directory path
# @return A hash of hpclib::rsync_cron
Puppet::Parser::Functions::newfunction(
  :hpc_backup_rsync_crons,
  :type  => :rvalue,
  :arity => 2,
  :doc   =>
    "Return a hash of hpclib::rsync_cron from sources and a target base dir"
) do |args|
  sources = args[0]
  base_target_dir = args[1]

  result = hpc_backup_rsync_crons(sources, base_target_dir)

  begin
    result
  rescue Puppet::ParseError => internal_error
    if internal_error.original.nil?
      raise internal_error
    else
      raise internal_error.original
    end
  end
end
