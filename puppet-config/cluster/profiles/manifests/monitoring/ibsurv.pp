class profiles::monitoring::ibsurv {

  $cron_file = hiera('profiles::monitoring::ibsurv::cron_file')
  $cron_source = hiera('profiles::monitoring::ibsurv::cron_source')
  $getiberr_file = hiera('profiles::monitoring::ibsurv::getiberr_file')
  $getiberr_source = hiera('profiles::monitoring::ibsurv::getiberr_source')
  $managedb_file = hiera('profiles::monitoring::ibsurv::managedb_file')
  $managedb_source = hiera('profiles::monitoring::ibsurv::managedb_source')
  $createdb_file = hiera('profiles::monitoring::ibsurv::createdb_file')
  $createdb_source = hiera('profiles::monitoring::ibsurv::createdb_source')
  $node_cfg = hiera('profiles::monitoring::ibsurv::nodecfg')

  class { '::icinga2::ibsurv':
    node_cfg => $node_cfg,
    cron_file => $cron_file,
    cron_source => $cron_source,
    getiberr_file => $getiberr_file,
    getiberr_source => $getiberr_source,
    managedb_file => $managedb_file,
    managedb_source => $managedb_source,
    createdb_file => $createdb_file,
    createdb_source => $createdb_source,
  }

}
