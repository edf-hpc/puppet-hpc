#
class boothttp::config inherits boothttp {

  create_resources(boothttp::printconfig, $boothttp::supported_os)

}
