# noinspection RubyResolve
require 'spec_helper'

describe 'ocsinventoryagent' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { {'zypper_repo_url' => 'https://example.com'} }

      it { is_expected.to compile }
      # noinspection RubyResolve
      it { is_expected.to contain_file('/etc/ocsinventory') }
      # noinspection RubyResolve
      it { is_expected.to contain_file('/etc/ocsinventory/ocsinventory-agent.cfg') }

      if os_facts[:os]['family'] == 'Suse'
        it { is_expected.to have_package_resource_count(7) }
        # noinspection RubyResolve
        it { is_expected.to contain_zypprepo('ocsinventory-repo') }
      elsif os_facts[:os]['family'] == 'RedHat'
        it { is_expected.to have_package_resource_count(14) }
      elsif os_facts[:os]['family'] == 'Debian'
        it { is_expected.to have_package_resource_count(2) }
      else
        raise 'OS-Family %s unkown' % os_facts[:os]['family']
      end
    end
  end
end
