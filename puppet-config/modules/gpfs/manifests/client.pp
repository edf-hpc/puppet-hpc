#
class gpfs::client (
  $cl_dir_mode       = $gpfs::params::cl_dir_mode,
  $cl_file_mod       = $gpfs::params::cl_file_mode,
  $cl_decrypt_passwd = $gpfs::params::cl_decrypt_passwd,
  $cl_packages       = $gpfs::params::cl_packages,
  $cl_packages_ensure= $gpfs::params::cl_packages_ensure,
  $cl_config_dir     = $gpfs::params::cl_config_dir,
  $cl_config         = $gpfs::params::cl_config,
  $cl_config_src     = $gpfs::params::cl_config_src,
  $cl_key            = $gpfs::params::cl_key,
  $cl_key_src        = $gpfs::params::cl_key_src,
  $cl_perf           = $gpfs::params::cl_perf,
  $cl_perf_src       = $gpfs::params::cl_perf_src,
) inherits gpfs::params {
  
  validate_string($cl_dir_mode)
  validate_string($cl_file_mod)
  validate_string($cl_decrypt_passwd)
  validate_array($cl_packages)
  validate_string($cl_packages_ensure)
  validate_array($cl_config_dir)
  validate_absolute_path($cl_config)
  validate_string($cl_config_src)
  validate_absolute_path($cl_key)
  validate_string($cl_key_src)
  validate_absolute_path($cl_perf)
  validate_string($cl_perf_src)

  anchor { 'gpfs::client::begin': } ->
  class { '::gpfs::client::install': } ->
  class { '::gpfs::client::config': } ->
  anchor { 'gpfs::client::end': }

}
