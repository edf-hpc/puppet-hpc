require 'spec_helper'                

describe 'hpclib::sysctl' do

  let(:title) { 'sysctl' }
  let(:params) { { :sysctl_file => 'foo', :config => {"Unit" => { "Description" => "foo", "Documentation" => "bar"} } } }

  context 'Sysctl file must be created' do
    it { 
      should contain_file('/etc/sysctl.d/foo')
    } 
  end

  context 'Sysctl file must be created' do
    it { 
      should contain_hpclib__print_config('foo').with(
         'style'   => 'keyval',
         'target'  => '/etc/sysctl.d/foo',
         'require' => 'File[/etc/sysctl.d]',
      )
    } 
  end

  context 'Sysctl config must be activated' do 
    it {
      should contain_exec('sysctl_foo').with(
        'command'   => 'sysctl -p /etc/sysctl.d/foo',
        'subscribe' => 'File[/etc/sysctl.d/foo]',
        'path'      => ["/bin","/sbin"],
      )       
    }
  end

end
