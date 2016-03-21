#
class profiles::nfs::exports {

  # Hiera lookups
  $to_export = hiera_hash('nfs::to_export')

  # Initialize nfs_server
  class { '::nfs_server': }
 
  # Mount all the specified directories
  create_resources('::nfs_server::export', $to_export)

}
