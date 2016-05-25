#
class iscdhcp (
  
  $my_address,
  $peer_address               = $iscdhcp::params::peer_address,
  $virtual_address            = $iscdhcp::params::virtual_address,
  $bootmenu_url               = $iscdhcp::params::bootmenu_url,
  $ipxebin                    = $iscdhcp::params::ipxebin,
  $includes                   = $iscdhcp::params::includes,
  $dhcp_config                = $iscdhcp::params::dhcp_config,
  $packages                   = $iscdhcp::params::packages,
  $packages_ensure            = $iscdhcp::params::packages_ensure,
  $config_file                = $iscdhcp::params::config_file,
  $global_options             = $iscdhcp::params::global_options,
  $failover                   = $iscdhcp::params::failover,
  $sharednet                  = $iscdhcp::params::sharednet,
  $default_file               = $iscdhcp::params::default_file,
  $default_options            = $iscdhcp::params::default_options,
  $service                    = $iscdhcp::params::service,
  $service_ensure             = $iscdhcp::params::service_ensure,
  $systemd_config_file        = $iscdhcp::params::systemd_config_file,
  $systemd_config_options     = $iscdhcp::params::systemd_config_options,

) inherits iscdhcp::params {

  validate_string($my_address)
  validate_string($peer_address)
  validate_string($virtual_address)
  validate_string($bootmenu_url)
  validate_string($ipxebin)
  validate_hash($includes)
  validate_hash($dhcp_config)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_array($global_options)
  validate_hash($failover)
  validate_hash($sharednet)
  validate_absolute_path($default_file) 
  validate_array($default_options)
  validate_string($service)
  validate_string($service_ensure)
  validate_absolute_path($systemd_config_file)
  validate_hash($systemd_config_options)

  anchor { 'iscdhcp::begin': } ->
  class { '::iscdhcp::install': } ->
  class { '::iscdhcp::config': } ->
  class { '::iscdhcp::service': }
  anchor { 'iscdhcp::end': }

}
