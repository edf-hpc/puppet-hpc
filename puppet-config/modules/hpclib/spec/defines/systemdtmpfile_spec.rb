require 'spec_helper'                

describe 'hpclib::systemd_tmpfile' do

  let(:title) { 'systemdtmpfile' }

  context 'Systemd temp file must be created' do
    let(:params) { { :target => '/tmp/foo', :config => ['foo', 'bar', 'toto'] } }
    it { 
      should contain_file('/tmp/foo')
    } 
  end

end
