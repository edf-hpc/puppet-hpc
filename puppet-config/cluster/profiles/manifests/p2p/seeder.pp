class profiles::p2p::seeder {

  ## Hiera lookups

  $cluster          = hiera('cluster')
  $ctorrent_options = hiera('profiles::p2p::seeder::ctorrent_cfg')


  class { '::ctorrent':
    cluster          => $cluster,
    ctorrent_options => $ctorrent_options,
  }
}
