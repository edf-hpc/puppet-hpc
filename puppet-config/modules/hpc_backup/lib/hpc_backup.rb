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

require 'hpc/nodeset'
require 'hpc/profiles'

def hpc_backup_rsync_crons(sources, base_target_dir)
  # Take a hash of sources and build hpclib::rsync_cron descriptions
  # sources are of the form:
  #   'slurmdbd':
  #     source_profiles:
  #       - 'profiles::jobsched::server'
  #     source_dir: '/var/backups/slurmdbd'
  rsync_crons = Hash.new()

  mandatory_params = ['source_profiles', 'source_dir']

  sources.each do |source_name, source_params|
    debug("Add source #{source_name} (#{source_params})")

    if source_name =~ /[^A-Za-z0-9_\.\-]+/
      raise "Source name '#{source_name}' invalid, valid chars: A-Za-z0-9_\.\-"
    end

    mandatory_params.each do |param_name|
      if not source_params.key?(param_name)
        raise "Source '#{source_name}' has no param '#{param_name}'"
      end
    end

    hosts = Array.new()
    profiles =  source_params['source_profiles']
    profiles.each do |profile|
      hosts |= get_hosts_by_profile(profile)
    end
    debug("source #{source_name} host list: #{hosts}")

    hosts.each do |host|
      rsync_cron = Hash.new()
      rsync_cron_name = "#{host}_#{source_name}"
      rsync_cron['source_host'] = host
      rsync_cron['source_dir']  = source_params['source_dir']
      rsync_cron['target_dir']  = File.join(base_target_dir, rsync_cron_name)
      rsync_crons[rsync_cron_name] = rsync_cron
    end
  end

  return rsync_crons
end

