class ssmtp::params {

#### Module variables

  $pkgs  = ['ssmtp', 'mailutils']
  $cfg   = '/etc/ssmtp/ssmtp.conf'

#### Default variables
  $cfg_opts = {
    'mailhub'       => '',
    'rewritedomain' => '',
  }

}
