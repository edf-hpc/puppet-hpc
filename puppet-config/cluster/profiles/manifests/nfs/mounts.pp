#
class profiles::nfs::mounts {

  # Hiera lookups
  $to_mount = hiera_hash('nfs::to_mount')

  # Initialize nfs_client
  class { '::nfs_client': }
 
  # Mount all the specified directories
  create_resources('::nfs_client::mount', $to_mount)

}
