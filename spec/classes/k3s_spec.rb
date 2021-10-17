# frozen_string_literal: true

require 'spec_helper'

describe 'k3s' do
  on_supported_os.each do |os, os_facts|
    context "install - on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          ensure: 'present',
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('k3s::install') }
    end
    context "uninstall - on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          ensure: 'absent',
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('k3s::uninstall') }
    end
  end
end
