#
class network::service inherits network {

  # Install systemd services on supported OS.
  if $::operatingsystem == 'Debian' and $::operatingsystemmajrelease == '8' {

    hpclib::systemd_tmpfile { $network::systemd_tmpfile :
      target => $network::systemd_tmpfile,
      config => $network::systemd_tmpfile_conf,
    }

    # Enable systemd service ifup-hotplug to ensure it is run at server boot.
    # If service provider is systemd (calibre9 running production),
    # use Puppet service type.
    # If service provider is debian (calibre9 during the late_command
    # of debian installer), use Puppet file type since systemd/systemctl is not
    # running at this stage.
    case $::puppet_context {
      'ondisk', 'diskless-postinit': {
        hpclib::systemd_service { $network::ifup_hotplug_service_file :
          target => $network::ifup_hotplug_service_file,
          config => $network::ifup_hotplug_service_params,
        }
        create_resources(service, $network::ifup_hotplug_services)
      }
      'installer', 'diskless-preinit': {
        create_resources(file, $network::ifup_hotplug_files)
      }
      default : {}
    }
  }
  else {
    notice("unsupported service provider for class ${class}")
  }

}
