#
class gpfs::server::install inherits gpfs::server {

  if ! empty( $gpfs::server::sr_packages) {
    package { $gpfs::server::sr_packages :
      ensure  => $gpfs::server::sr_packages_ensure,
    }
  }

}
