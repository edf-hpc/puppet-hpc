class profiles::auth::replica {

  ## Hiera lookups

  $ldif_directory_source = hiera('profiles::auth::replica::ldif_directory_source')
  $ldif_file             = hiera('profiles::auth::replica::ldif_file')
  $ldif_directory        = hiera('profiles::auth::replica::ldif_directory')
  $cluster               = hiera('cluster')

  # Pass config options as a class parameter
  class { '::openldap':
  } ->

  class { '::openldap::replica' :
    ldif_directory_source => $ldif_directory_source,
    ldif_file             => $ldif_file,
    ldif_directory        => $ldif_directory,
  } 
}
