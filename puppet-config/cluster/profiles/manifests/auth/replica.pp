class profiles::auth::replica {

  ## Hiera lookups

  $directory_source = hiera('profiles::auth::replica::directory_source')
  $ldif_file        = hiera('profiles::auth::replica::ldif_file')
  $ldif_directory   = hiera('profiles::auth::replica::ldif_directory')
  $cluster          = hiera('cluster')

  # Pass config options as a class parameter
  include certificates 

  include ::openldap

  class { '::openldap::replica' :
    directory_source => $directory_source,
    ldif_file        => $ldif_file,
    ldif_directory   => $ldif_directory,
  } 
}
