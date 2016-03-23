#
class gpfs::client::install inherits gpfs::client {

  package { $gpfs::client::cl_packages :
    ensure  => $gpfs::client::cl_packages_ensure,
  }

}
