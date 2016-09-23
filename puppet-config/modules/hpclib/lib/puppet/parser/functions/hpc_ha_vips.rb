#!/usr/bin/env ruby
##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

require('hpc/ha')

# @return A hash of VIP hash for the current host
Puppet::Parser::Functions::newfunction(
  :hpc_ha_vips,
  :type  => :rvalue,
  :arity => -1,
  :doc   =>
    "Return a hash of VIP hash for the current host"
) do |args|

  result = hpc_ha_vips()

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
