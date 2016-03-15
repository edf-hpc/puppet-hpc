class slurmclient::config {

  if $slurmclient::config_manage {
    require slurmcommons 
  } 
}
