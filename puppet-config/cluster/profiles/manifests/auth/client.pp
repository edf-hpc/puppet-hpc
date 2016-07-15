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

# Authentication system client
#
# ## Hiera
# * `cluster`
# * `profiles::auth::client::enable_kerberos`
# * `profiles::auth::client::krb5_server`
# * `profiles::auth::client::krb5_realm`
# * `profiles::auth::client::krb5_store_password_if_offline`
# * `profiles::auth::client::sssd_options_general` (`hiera_hash`)
# * `profiles::auth::client::sssd_options_nss` (`hiera_hash`)
# * `profiles::auth::client::sssd_options_pam` (`hiera_hash`)
# * `profiles::auth::client::sssd_options_domain` (`hiera_hash`)
# * `profiles::auth::client::krb5_options` (`hiera_hash`)
#
# ## Relevant Autolookup
# * `kerberos::keytab_source_dir` Directory where the keytabs are sourced (with `hpclib::decrypt`)
# * `kerberos::decrypt_passwd`    Password to decrypt keytabs (with `hpclib::decrypt`)
class profiles::auth::client {

  ## Hiera lookups

  $sssd_options_general = hiera_hash('profiles::auth::client::sssd_options_general')
  $sssd_options_nss     = hiera_hash('profiles::auth::client::sssd_options_nss')
  $sssd_options_pam     = hiera_hash('profiles::auth::client::sssd_options_pam')
  $sssd_options_domain  = hiera_hash('profiles::auth::client::sssd_options_domain')
  $krb5_options         = hiera_hash('profiles::auth::client::krb5_options')
  $enable_kerberos      = hiera('profiles::auth::client::enable_kerberos')
  $cluster              = hiera('cluster')

  if $enable_kerberos {
    $sssd_options_domain_kerberos_opts = {
      krb5_server                    => hiera('profiles::auth::client::krb5_server'),
      krb5_realm                     => hiera('profiles::auth::client::krb5_realm'),
      krb5_store_password_if_offline => hiera('profiles::auth::client::krb5_store_password_if_offline'),
      auth_provider                  => 'krb5',
    }
    class { '::kerberos':
      config_options    => $krb5_options,
      keytab_source_dir => $directory_source,
    }
  }
  else {
    $sssd_options_domain_kerberos_opts = {
      auth_provider                  => 'ldap',
    }
  }

  $sssd_options = {
    sssd => $sssd_options_general,
    nss  => $sssd_options_nss,
    pam  => $sssd_options_pam,
    "domain/${cluster}" => merge($sssd_options_domain,$sssd_options_domain_kerberos_opts),
  }

  include certificates

  class { '::sssd':
    sssd_options    => $sssd_options,
    cluster         => $cluster,
  }

  include ::pam
  include ::pam::sss
}
