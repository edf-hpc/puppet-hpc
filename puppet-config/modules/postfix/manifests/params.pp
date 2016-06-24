##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2016 EDF S.A.                                      #
#  Contact: CCN-HPC <dsp-cspit-ccn-hpc@edf.fr>                           #
#                                                                        #
#  This program is free software; you can redistribute in and/or         #
#  modify it under the terms of the GNU General Public License,          #
#  version 2, as published by the Free Software Foundation.              #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
##########################################################################

class postfix::params {
  #### Module variables
  $packages        = ['postfix']
  $packages_ensure = installed
  $service         = 'postfix'
  $service_ensure  = running
  $service_enable  = true
  $config_file     = '/etc/postfix/main.cf'

  #### Default values
  $config_options_default = {
    alias_database                      => 'hash:/etc/aliases',
    alias_maps                          => 'hash:/etc/aliases',
    append_dot_mydomain                 => 'yes',
    biff                                => 'no',
    command_directory                   => '/usr/sbin',
    data_directory                      => '/var/lib/postfix',
    debug_peer_level                    => '2',
    html_directory                      => 'no',
    inet_interfaces                     => 'loopback-only',
    inet_protocols                      => 'ipv4',
    mail_owner                          => 'postfix',
    mailbox_size_limit                  => '0',
    mailq_path                          => '/usr/bin/mailq.postfix',
    mydestination                       => '$mydomain, $myhostname, localhost.$mydomain, localhost',
    mydomain                            => "${::hostname}.${::domain}",
    myhostname                          => $::hostname,
    mynetworks                          => '127.0.0.0/8',
    myorigin                            => '$mydomain',
    newaliases_path                     => '/usr/bin/newaliases.postfix',
    queue_directory                     => '/var/spool/postfix',
    readme_directory                    => 'no',
    recipient_delimiter                 => '',
    relay_domains                       => '$mydestination',
    relayhost                           => '',
    sendmail_path                       => '/usr/sbin/sendmail.postfix',
    setgid_group                        => 'postdrop',
    smtp_host_lookup                    => 'dns,native',
    smtpd_banner                        => '$myhostname ESMTP $mail_name',
    smtpd_recipient_restrictions        => 'permit_mynetworks permit_sasl_authenticated check_relay_domains defer_unauth_destination',
    smtpd_use_tls                       => 'no',
    unknown_local_recipient_reject_code => '550',
    mailbox_command                     => 'procmail -a "$EXTENSION"',
    default_transport                   => 'error',
    relay_transport                     => 'error',
  }
}
