#
class gpfs::server (
  $sr_packages       = $gpfs::params::sr_packages,
  $sr_packages_ensure= $gpfs::params::sr_packages_ensure,
) inherits gpfs::params {

  validate_array($sr_packages)
  validate_string($sr_packages_ensure)

  class { 'gpfs::server::install': }

}
