#
class nfs_client (
  $pkgs            = $nfs_client::params::pkgs, 
  $pkgs_ensure     = $nfs_client::params::pkgs_ensure, 
  $serv            = $nfs_client::params::serv,
  $serv_ensure     = $nfs_client::params::serv_ensure,
) inherits nfs_client::params {
  
  validate_array($pkgs)
  validate_string($pkgs_ensure)
  validate_string($serv)
  validate_string($serv_ensure)

  class { 'nfs_client::install': }
  class { 'nfs_client::service': }

} 
