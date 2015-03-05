require 'spec_helper'
describe 'sshdmn' do

  context 'with defaults for all parameters' do
    it { should contain_class('sshdmn') }
  end
end
