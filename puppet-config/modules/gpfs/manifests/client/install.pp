#
class gpfs::client::install inherits gpfs::client {

  package { $gpfs::client::packages :
    ensure  => $gpfs::client::packages_ensure,
  }

}
