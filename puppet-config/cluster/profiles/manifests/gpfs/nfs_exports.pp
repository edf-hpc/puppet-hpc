#
class profiles::gpfs::nfs_exports {

  # Hiera lookups
  $to_export = hiera_hash('gpfs::nfs_to_export')

  # Install gpfs client
  class { '::gpfs::client': }

  # Install gpfs server 
  class { '::gpfs::server': }

  # Set up multipath
  class { '::multipath': }

  # Mount all the specified directories
  create_resources('::gpfs::server::export', $to_export)

}
