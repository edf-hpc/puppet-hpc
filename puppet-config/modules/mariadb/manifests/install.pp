class mariadb::install {

  if $mariadb::package_manage {

    case $::osfamily {
    'RedHat': {

      package { $mariadb::package_name :
        ensure       => $mariadb::package_ensure,
      }

    }
    'Debian': {
   
      file { $mariadb::mariadb_preseed_file :
        content      => template($mariadb::mariadb_preseed_tmpl),
        mode         => '0400',
        owner        => 'root',
        backup       => false,
      }

      package { $mariadb::package_name :
        ensure       => $mariadb::package_ensure,
        responsefile => $mariadb::mariadb_preseed_file,
        require      => File[$mariadb::mariadb_preseed_file] 
      }
    }
  }
}
