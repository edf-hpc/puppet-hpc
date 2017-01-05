#########################################################################
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

class s3cmd::params {
  $packages                 = ['s3cmd']
  $packages_ensure          = 'present'
  $config_file              = '/root/.s3cfg'
  $config_options_defaults  = {
    'default' => {
      bucket_location                     => 'US',
      cloudfront_host                     => 'cloudfront.amazonaws.com',
      default_mime_type                   => 'binary/octet-stream',
      delay_updates                       => 'False',
      delete_after                        => 'False',
      delete_after_fetch                  => 'False',
      delete_removed                      => 'False',
      dry_run                             => 'False',
      enable_multipart                    => 'True',
      encoding                            => 'UTF-8',
      encrypt                             => 'False',
      follow_symlinks                     => 'False',
      force                               => 'False',
      get_continue                        => 'False',
      gpg_command                         => '/usr/bin/gpg',
      gpg_decrypt                         => '%(gpg_command)s -d --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s',
      gpg_encrypt                         => '%(gpg_command)s -c --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s',
      guess_mime_type                     => 'True',
      human_readable_sizes                => 'False',
      ignore_failed_copy                  => 'False',
      invalidate_default_index_on_cf      => 'False',
      invalidate_default_index_root_on_cf => 'True',
      invalidate_on_cf                    => 'False',
      list_md5                            => 'False',
      max_delete                          => '-1',
      multipart_chunk_size_mb             => '15',
      preserve_attrs                      => 'True',
      progress_meter                      => 'True',
      proxy_port                          => '0',
      put_continue                        => 'False',
      recursive                           => 'False',
      recv_chunk                          => '4096',
      reduced_redundancy                  => 'False',
      restore_days                        => '1',
      send_chunk                          => '4096',
      server_side_encryption              => 'False',
      skip_existing                       => 'False',
      socket_timeout                      => '300',
      urlencoding_mode                    => 'normal',
      use_https                           => 'False',
      use_mime_magic                      => 'True',
      verbosity                           => 'WARNING',
      website_index                       => 'index.html',
      },
  }

}
