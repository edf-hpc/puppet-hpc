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
# Authentication uses the SSS daemon to configure node directory and
# authentication. The common pattern supported by this profile is a local
# LDAP replica and an external Kerberos server for authentication.
#
# ## SSSD
#
# SSSD is configured with four hiera keys
# (`profiles::auth::client::sssd_options_*`), those options are combined
# to create `sssd_options` used to generate the file `/etc/sssd/sssd.conf`
#
# ## Kerberos
#
# If the `enable_kerberos` hiera boolean is true, the options related to
# kerberos are also generated.
#
# ## Example
#
# The example below relies on some other hiera variables like
# `profiles::auth::ldap_default_authtok` that should define the password.
#
# `certificates::certificates_directory` is defined with the keys for the
# replica configuration.
#
# If you have a trusted certificate, you should pay attention to the
# `ldap_tls_reqcert` value that should use `require` in production.
#
# ```
# profiles::auth::client::enable_kerberos: false
# kdc_primary:                    'kdc1.example.com'
# kdc_secondary:                  'kdc2.example.com'
# external_ldap:                  'ldap.example.com'
# krb5_realm:                     'EXAMPLE.COM'
#
# profiles::auth::client::sssd_options_general:
#   config_file_version:  '2'
#   reconnection_retries: '3'
#   sbus_timeout:         '30'
#   services:             'nss,pam'
#   domains:              "%{hiera('cluster')}"
# profiles::auth::client::sssd_options_nss:
#   filter_groups:        'root'
#   filter_users:         'root'
#   reconnection_retries: '3'
# profiles::auth::client::sssd_options_pam:
#   reconnection_retries:           '3'
#   offline_credentials_expiration: '1'
# profiles::auth::client::sssd_options_domain:
#   name:                      "%{hiera('cluster')}"
#   description:               "LDAP replica for %{hiera('cluster')}"
#   id_provider:               'ldap'
#   auth_provider:             'krb5'
#   cache_credentials:         'true'
#   enumerate:                 'true'
#   min_id:                    '1000'
#   ldap_uri:                  "ldaps://%{hiera('cluster_prefix')}%{my_auth_replica}1, ldaps://%{hiera('cluster_prefix')}%{my_auth_replica}2"
#   ldap_tls_reqcert:          'allow'
#   ldap_tls_cacert:           "%{hiera('certificates::certificates_directory')}"
#   ldap_search_timeout:       '3'
#   ldap_network_timeout:      '2'
#   ldap_pwd_policy:           ''
#   case_sensitive:            "%{hiera('sssd::case_sensitive')}"
#   account_cache_expiration:  '1'
#   ldap_user_gecos:           'cn'
#   ldap_schema:               'rfc2307bis'
#   ldap_search_base:          'dc=example,dc=com'
#   ldap_default_bind_dn:      'cn=nss,ou=infra,dc=example,dc=com'
#   ldap_default_authtok_type: 'password'
#   ldap_default_authtok:      "%{hiera('profiles::auth::ldap_default_authtok')}"
#   ldap_user_search_base:     'ou=people,dc=example,dc=com'
#   ldap_group_search_base:    'ou=groups,dc=example,dc=com'
# profiles::auth::client::krb5_server:                    "%{hiera('kdc_primary')}, %{hiera('kdc_secondary')}"
# profiles::auth::client::krb5_realm:                     "%{hiera('krb5_realm')}"
# profiles::auth::client::krb5_store_password_if_offline: 'true'
#
# profiles::auth::client::krb5_options:
#   libdefaults:
#     default_realm:    "%{hiera('krb5_realm')}"
#     rdns:             'false'
#     dns_lookup_realm: 'false'
#     dns_lookup_kdc:   'false'
#     forwardable:      'true'
#   realms:
#     "%{hiera('krb5_realm')}": |-
#       {
#         kdc = %{hiera('kdc_primary')}
#         kdc = %{hiera('kdc_secondary')}
#         admin_server = %{hiera('external_ldap')}
#         kpasswd_server = %{hiera('external_ldap')}
#         default_domain = example.com
#       }
#   domain_realm:
#     '.EXAMPLE.COM': "%{hiera('krb5_realm')}"
#     'EXAMPLE.COM':  "%{hiera('krb5_realm')}"
#
# kerberos::keytab_source_dir: "%{hiera('private_files_dir')}/auth/keytabs"
# kerberos::decrypt_passwd:    "%{hiera('cluster_decrypt_password')}"
# ```
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
    }
  }
  else {
    $sssd_options_domain_kerberos_opts = {
      auth_provider => 'ldap',
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
    sssd_options => $sssd_options,
    cluster      => $cluster,
  }

  include ::pam
  include ::pam::sss
}
