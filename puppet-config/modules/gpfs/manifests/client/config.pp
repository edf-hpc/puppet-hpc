#
class gpfs::client::config inherits gpfs::client {

  file { $gpfs::cl_config_dir :
    ensure           => 'directory'
  }
  
  # Configuration files to install
  # It is assumed specified configuration files are encrypted
  $gpfs_cl_files = {
    "${gpfs::client::cl_config}" => {
      content  => decrypt($gpfs::client::cl_config_src, $gpfs::client::cl_decrypt_passwd),
      mode     => $gpfs::client::cl_file_mode,
    },
    "${gpfs::client::cl_key}" => {
      content  => decrypt($gpfs::client::cl_key_src, $gpfs::client::cl_decrypt_passwd),
    },
    "${gpfs::client::cl_perf}" => {
      source   => $gpfs::client::cl_perf_src,
      ensure   => 'directory',
      mode     => $gpfs::client::cl_dir_mode,
      recurse  => 'remote',
    },
  }
  # Default settings to apply to all files
  $gpfs_cl_files_def = {
    require    => Package[$gpfs::client::cl_packages],
  }
  create_resources(file,$gpfs_cl_files,$gpfs_cl_files_def)

}
