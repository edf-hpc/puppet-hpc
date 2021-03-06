##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2017 EDF S.A.                                      #
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
# authentication. The profile can configure SSSD to authenticate against either
# an internal LDAP replica or an external reference LDAP server. The optional
# Kerberos configuration necessarily connect to an external server.
#
# ## SSSD
#
# SSSD is configured with four hiera keys
# (`profiles::auth::client::sssd_options_*`), those options are combined
# to create `sssd_options` used to generate the file `/etc/sssd/sssd.conf`
#
# The URI to the LDAP server depends on the value of the boolean `external_ldap`
# parameter. If true, the URI is the value of `ldap_external_uri`, otherwise
# (default) it is `ldap_internal_uri`.
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
# ldap_external:                  'ldap.example.com
# krb5_realm:                     'EXAMPLE.COM'
#
# profiles::auth::client::external_ldap: false
# profiles::auth::client::sssd_options_general:
#   config_file_version:  '2'
#   reconnection_retries: '3'
#   sbus_timeout:         '30'
#   services:             'nss,pam'
#   domains:              "%{hiera('cluster_name')}"
# profiles::auth::client::sssd_options_nss:
#   filter_groups:        'root'
#   filter_users:         'root'
#   reconnection_retries: '3'
# profiles::auth::client::sssd_options_pam:
#   reconnection_retries:           '3'
#   offline_credentials_expiration: '1'
# profiles::auth::client::ldap_external_uri: "ldaps://%{hiera('ldap_external_primary')}, ldaps://%{hiera('ldap_external_secondary')}"
# profiles::auth::client::ldap_internal_uri: "ldaps://%{hiera('ldap_internal_primary')}, ldaps://%{hiera('ldap_internal_secondary')}"
# profiles::auth::client::sssd_options_domain:
#   name:                      "%{hiera('cluster_name')}"
#   description:               "LDAP replica for %{hiera('cluster_name')}"
#   id_provider:               'ldap'
#   auth_provider:             'krb5'
#   cache_credentials:         'true'
#   enumerate:                 'true'
#   min_id:                    '1000'
#   ldap_tls_reqcert:          'allow'
#   ldap_tls_cacert:           "%{hiera('certificates::certificates_directory')}"
#   ldap_search_timeout:       '3'
#   ldap_network_timeout:      '2'
#   ldap_pwd_policy:           ''
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
#         admin_server = %{hiera('ldap_external')}
#         kpasswd_server = %{hiera('ldap_external')}
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
# * `cluster_name`
# * `profiles::auth::client::enable_kerberos`
# * `profiles::auth::client::krb5_server`
# * `profiles::auth::client::krb5_realm`
# * `profiles::auth::client::krb5_store_password_if_offline`
# * `profiles::auth::client::sssd_options_general` (`hiera_hash`)
# * `profiles::auth::client::sssd_options_nss` (`hiera_hash`)
# * `profiles::auth::client::sssd_options_pam` (`hiera_hash`)
# * `profiles::auth::client::sssd_options_domain` (`hiera_hash`)
# * `profiles::auth::client::external_ldap` (default value: false)
# * `profiles::auth::client::ldap_external_uri`
# * `profiles::auth::client::ldap_internal_uri`
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
  $cluster              = hiera('cluster_name')
  $external_ldap        = hiera('profiles::auth::client::external_ldap', false)

  # Get external or internal LDAP URI depending on external_ldap boolean value
  if $external_ldap == true {
    $ldap_uri = hiera('profiles::auth::client::ldap_external_uri')
  } else {
    $ldap_uri = hiera('profiles::auth::client::ldap_internal_uri')
  }

  # insert ldap_uri into sssd_options_domain hash
  $_sssd_options_domain_uri = {
    ldap_uri => $ldap_uri,
  }
  $_sssd_options_domain = merge($sssd_options_domain,
                                $_sssd_options_domain_uri)

  if $enable_kerberos {
    $sssd_options_domain_kerberos_opts = {
      krb5_server                    => hiera('profiles::auth::client::krb5_server'),
      krb5_realm                     => hiera('profiles::auth::client::krb5_realm'),
      krb5_store_password_if_offline => hiera('profiles::auth::client::krb5_store_password_if_offline'),
      auth_provider                  => 'krb5',
      krb5_lifetime                  => hiera('profiles::auth::client::krb5_lifetime'),
      krb5_renewable_lifetime        => hiera('profiles::auth::client::krb5_renewable_lifetime'),
      krb5_renew_interval            => hiera('profiles::auth::client::krb5_renew_interval'),
      krb5_auth_timeout              => hiera('profiles::auth::client::krb5_auth_timeout'),
      krb5_validate                  => hiera('profiles::auth::client::krb5_validate'),
    }
    class { '::kerberos':
      config_options => $krb5_options,
    }
  }
  else {
    $sssd_options_domain_kerberos_opts = {
      auth_provider => 'ldap',
    }
  }

  $sssd_options = {
    sssd                => $sssd_options_general,
    nss                 => $sssd_options_nss,
    pam                 => $sssd_options_pam,
    "domain/${cluster}" => merge($_sssd_options_domain,
                                 $sssd_options_domain_kerberos_opts),
  }

  include certificates

  class { '::sssd':
    sssd_options => $sssd_options,
    cluster      => $cluster,
  }

  include ::pam
  include ::pam::sss
}
