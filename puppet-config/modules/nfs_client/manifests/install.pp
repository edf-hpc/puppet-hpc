#
class nfs_client::install inherits nfs_client {
  
  package { $nfs_client::pkgs:
    ensure => $nfs_client::pkgs_ensure,
  }

}
