require 'spec_helper'                
describe 'ctorrent' do
  context 'The following classes should be present in the catalog' do
    
    it { should compile }                # this is the test to check if it compiles. 
  
  end

  context 'The main class should be present in the catalog' do
    it { 
         should contain_class('ctorrent') 
    }
  end

  context 'The main class should create the installation class' do
    it {
         should create_class('ctorrent::install')
    }
  end

  context 'The main class should create the config class' do
    it { 
         should create_class('ctorrent::config')
    } 
  end

  context 'The main class should create the service class' do
    it { 
         should create_class('ctorrent::service')
    }
  end

  context 'Install ctorrent package' do
    it {
          should contain_package('ctorrent')
            .with_ensure ('latest')
    }
  end

  context 'Install ctorrent config file' do
    it {
          should contain_file('/etc/default/ctorrent').with(
            'ensure'  => 'present',
            'require' => 'Package[ctorrent]',
            'notify'  => 'Service[ctorrent]',
          )
    }
  end

  context 'Install ctorrent daemon init file' do
    it {
          should contain_file('/etc/init.d/ctorrent').with(
            'ensure'  => 'present',
            'source'  => 'puppet:///modules/ctorrent/ctorrent.init',
            'mode'    => '0755',
            'require' => 'Package[ctorrent]',
          )
    }
  end



 
end
