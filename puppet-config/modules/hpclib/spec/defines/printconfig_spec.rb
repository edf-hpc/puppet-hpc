require 'spec_helper'                

describe 'hpclib::print_config' do

  let(:title) { 'printconfig' }

  context 'target must be printed' do
    let(:params) { { :target => '/tmp/foo', :data => {'foo' => 'bar'}, :style => 'keyval' } }
    it { 
      should contain_file('/tmp/foo').with(
        'owner' => 'root',
        'mode'  => '0644',
       ) 
    } 
  end

  context 'Print with keyval style' do 
    let(:params) { { :target => '/tmp/foo', :data => {'foo' => 'bar'}, :style => 'keyval' } }
    it {
      should contain_file('/tmp/foo').with_content(/keyval/)
       
    }
  end

  context 'Print with ini style' do
    let(:params) { { :target => '/tmp/foo', :data => {'foo' => { 'toto' => 'bar'}}, :style => 'ini' } }
    it { 
      should contain_file('/tmp/foo').with_content(/ini/) 
    } 
  end

  context 'Print with linebyline style' do
    let(:params) { { :target => '/tmp/foo', :data => ['foo'], :style => 'linebyline' } }
    it { 
      should contain_file('/tmp/foo').with_content(/linebyline/)
    } 
  end

  context 'Print with yaml style' do
    let(:params) { { :target => '/tmp/foo', :data => {'foo' => { 'toto' => 'bar'}}, :style => 'yaml' } }
    it { 
      should contain_file('/tmp/foo').with_content(/yaml/)
    } 
  end

end
