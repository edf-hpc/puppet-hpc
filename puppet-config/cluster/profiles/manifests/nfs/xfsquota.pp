class profiles::nfs::xfsquota {

  $target_link_projects = hiera('profiles::nfs::xfsquota::target_link_projects')
  $target_link_projid = hiera('profiles::nfs::xfsquota::target_link_projid')
  $source_mgnt_xfs_quota = hiera('profiles::nfs::xfsquota::source_mgnt_xfs_quota')
  $source_cron_xfs_quota = hiera('profiles::nfs::xfsquota::source_cron_xfs_quota')

  class { '::nfs::xfsquota':
    target_link_projid => $target_link_projid,
    target_link_projects => $target_link_projects,
    source_mgnt_xfs_quota => $source_mgnt_xfs_quota,
    source_cron_xfs_quota => $source_cron_xfs_quota,
  }

}

