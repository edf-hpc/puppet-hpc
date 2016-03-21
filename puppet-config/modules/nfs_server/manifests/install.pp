#
class nfs_server::install inherits nfs_server {

  package { $nfs_server::pkgs:
    ensure => $nfs_server::pkgs_ensure,
  }
  
  concat { $nfs_server::cfg:
    ensure => 'present',
  }

}
