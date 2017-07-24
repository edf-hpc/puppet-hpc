class alternatives::config inherits alternatives {

  if $::alternatives::config_manage {

    exec { "$exec_command --set $altname $altpath":
      unless => "$exec_command --query $altname|/bin/grep Link|/bin/grep $altpath",
    }
  }
}

