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

  # Install systemd services on supported OS.
  if $::operatingsystem == 'Debian' and $::operatingsystemmajrelease == '8' {
    tools::systemd_service { $ifup_hotplug_service_file :
      target => $ifup_hotplug_service_file,
      config => $ifup_hotplug_service_params,
    }

    tools::systemd_tmpfile { $systemd_tmpfile :
      target => $systemd_tmpfile,
      config => $systemd_tmpfile_conf,
    }

    # Enable systemd service ifup-hotplug to ensure it is run at server boot.
    # If service provider is systemd (calibre9 running production),
    # use Puppet service type.
    # If service provider is debian (calibre9 during the late_command
    # of debian installer), use Puppet file type since systemd/systemctl is not
    # running at this stage.
    case $::puppet_context {
      'ondisk', 'diskless-postinit': {
        create_resources(service, $ifup_hotplug_services)
      }
      'installer', 'diskless-preinit': {
        create_resources(file, $ifup_hotplug_files)
      }
      default : {}
    }
  }
  else {
    notice("unsupported service provider for class ${class}")
  }

  # Set hostname
  augeas { $aug_hname :
    context => $aug_hname,
    changes => $aug_changes,
  }

  $mlx_cfg = {
    'mlx4_load'    => $mlx4load,
    'mlx4_en_load' => $mlx4load,
  }
  $openib_cfg = merge($openib_cfg0, $mlx_cfg)

  # Install packages and create configuration files
  $ib_file = {
    "${ib_cfg}"    => {
      'content'            => template('network/openib_conf.erb'),
      'require'            => Package[$ib_pkgs],
    }
  }
  create_resources(file, $ib_file)

  # $net_ifaces hash is used by create_resources to generate main network
  # configuration file. On debian systems there is a single file.
  # On RHEL systems there is a file for each interface. For this reason
  # the hash is modified with the names of all interfaces in the case of RHEL.
  $net_ifaces = $::ifaces_target
  create_resources(network::printconfig, $net_ifaces)

  create_resources(package, $pkgs)
}
