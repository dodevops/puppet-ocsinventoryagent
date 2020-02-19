require 'spec_helper'

describe 'ocsinventoryagent' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_file('/etc/ocsinventory') }
      it { is_expected.to contain_file('/etc/ocsinventory/ocsinventory-agent.cfg')}

      if os_facts[:os]['family'] == 'Suse'
        it { is_expected.to have_package_resource_count(7) }
        it { is_expected.to contain_zypprepo('ocsinventory-repo') }
      elsif os_facts[:os]['family'] == 'RedHat'
        it { is_expected.to have_package_resource_count(14) }
      elsif os_facts[:os]['family'] == 'Debian'
        it { is_expected.to have_package_resource_count(2) }
      else
        fail(sprintf("OS-Family %s unkown", os_facts[:os]['family']))
      end
    end
  end
end
