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
    its(:sha256sum) { is_expected.to eq 'ce74caa56bdcef65458ee6a4af40ea03445216678c8aeef8a3fad514f1de5a81' }
  end

  describe command('ocsinventory-agent --version') do
    its(:exit_status) { is_expected.to eq 0 }
  end

  if host_inventory['platform'] == 'debian'
    describe file('/etc/cron.daily/ocsinventory-agent') do
      it { is_expected.to exist }
      it { is_expected.to be_file }
    end
  elsif host_inventory['platform'] == 'redhat'
    describe file('/etc/cron.hourly/ocsinventory-agent') do
      it { is_expected.to exist }
      it { is_expected.to be_file }
    end
  else
    describe file('/etc/cron.daily/ocsinventory-agent') do
      it { is_expected.to exist }
      it { is_expected.to be_file }
    end
  end
end
