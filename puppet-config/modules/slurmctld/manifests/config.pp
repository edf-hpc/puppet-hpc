class slurmctld::config {
  
  if $slurmctld::config_manage {

    require slurmcommons

    if $slurmctld::enable_topology {

      hpclib::print_config { $slurmctld::topo_conf_file :
        style        => 'linebyline',
        data         => $slurmctld::topology_conf,
      }
    }
    if $slurmctld::enable_lua {

      file { $slurmctld::submit_lua_script :
        source       => $slurmctld::submit_lua_source,
      }
    }

    if $slurmctld::enable_wckeys {

    # Work in progress 

    }
  }
}
