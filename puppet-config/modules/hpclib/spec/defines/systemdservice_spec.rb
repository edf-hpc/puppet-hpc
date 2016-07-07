require 'spec_helper'                

describe 'hpclib::systemd_service' do

  let(:title) { 'systemdservice' }
  let(:params) { { :target => '/tmp/foo', :config => {'Unit' => { 'Description' => 'foo', 'Documentation' => 'bar'} } } }

  context 'Systemd service file must be created' do
    it { 
      should contain_file('/tmp/foo')
    } 
  end

  context 'Systemd service must be activated' do 
    it {
      should contain_exec('/tmp/foo').with(
        'command'     => '/bin/systemctl daemon-reload && /bin/systemctl enable foo',
        'refreshonly' => true,
        'subscribe'   => 'File[/tmp/foo]',
        'require'     => 'File[/tmp/foo]',
      )       
    }
  end

end
