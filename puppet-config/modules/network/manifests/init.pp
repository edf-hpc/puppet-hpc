#
class network (
  $defaultgw,
  $routednet,
  $aug_hname                   = $network::params::aug_hname,
  $aug_changes                 = $network::params::aug_changes,
  $cfg                         = $network::params::cfg,
  $systemd_tmpfile             = $network::params::systemd_tmpfile,
  $systemd_tmpfile_conf        = $network::params::systemd_tmpfile_conf,
  $ifup_hotplug_service        = $network::params::ifup_hotplug_service,
  $ifup_hotplug_service_file   = $network::params::ifup_hotplug_service_file,
  $ifup_hotplug_service_link   = $network::params::ifup_hotplug_service_link,
  $ifup_hotplug_service_exec   = $network::params::ifup_hotplug_service_exec,
  $ifup_hotplug_service_params = $network::params::ifup_hotplug_service_params,
  $ifup_hotplug_services       = $network::params::ifup_hotplug_services,
  $ifup_hotplug_files          = $network::params::ifup_hotplug_files,
  $ib_udevrl                   = $network::params::ib_udevrl,
  $ib_cfg                      = $network::params::ib_cfg,
  $ib_rules                    = $network::params::ib_rules,
  $ib_pkgs                     = $network::params::ib_pkgs,
  $mlx4load                    = $network::params::mlx4load,
  $openib_cfg0                 = $network::params::openib_cfg0,
  $pkgs                        = $network::params::pkgs,
) inherits network::params {

  validate_string($defaultgw)
  validate_array($routednet)
  validate_string($aug_hname)
  validate_string($aug_changes)
  validate_absolute_path($cfg)
  validate_absolute_path($systemd_tmpfile)
  validate_array($systemd_tmpfile_conf)
  validate_string($ifup_hotplug_service)
  validate_absolute_path($ifup_hotplug_service_file)
  validate_absolute_path($ifup_hotplug_service_link)
  validate_string($ifup_hotplug_service_exec)
  validate_hash($ifup_hotplug_service_params)
  validate_hash($ifup_hotplug_services)
  validate_hash($ifup_hotplug_files)
  validate_absolute_path($ib_udevrl)
  validate_absolute_path($ib_cfg)
  validate_hash($ib_rules)
  validate_array($ib_pkgs)
  validate_string($mlx4load)
  validate_hash($openib_cfg0)
  validate_hash($pkgs)


  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'network::begin': } ->
  class { '::network::install': } ->
  class { '::network::config': } ~>
  class { '::network::service': } ->
  anchor { 'network::end': }

}
