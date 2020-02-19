# noinspection RubyResolve
require 'spec_helper'

# Check basic feature

describe 'After puppet' do
  describe file('/etc/ocsinventory') do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
  end
  describe file('/etc/ocsinventory/ocsinventory-agent.cfg') do
    it { is_expected.to exist }
    it { is_expected.to be_file }
    its(:content) do
      is_expected.to match %r{server=https://ocs.example.com}
      is_expected.to match %r{ca=/test/ca.pem}
    end
  end
end
