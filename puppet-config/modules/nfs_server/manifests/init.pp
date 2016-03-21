#
class nfs_server (
  $cfg                = $nfs_server::params::cfg,
  $pkgs               = $nfs_server::params::pkgs,
  $pkgs_ensure        = $nfs_server::params::pkgs_ensure, 
  $serv               = $nfs_server::params::serv,
  $serv_ensure        = $nfs_server::params::serv_ensure,
) inherits nfs_server::params {

  validate_absolute_path($cfg)
  validate_array($pkgs)
  validate_string($pkgs_ensure)
  validate_string($serv)
  validate_string($serv_ensure)

  class { 'nfs_server::install': }
  class { 'nfs_server::service': }

}
