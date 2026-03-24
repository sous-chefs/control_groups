# frozen_string_literal: true

control 'control-groups-entry-packages-01' do
  impact 1.0
  title 'Required packages are installed'

  %w(cgroup-tools libcgroup2 libpam-cgroup).each do |package_name|
    describe package(package_name) do
      it { should be_installed }
    end
  end
end

control 'control-groups-entry-config-01' do
  impact 1.0
  title 'Entry configuration is rendered'

  describe file('/etc/cgconfig.conf') do
    it { should exist }
    its('content') { should match(/group analytics \{/) }
    its('content') { should match(/cpu.max = 20000 100000;/) }
    its('content') { should match(/notify_on_release = 1;/) }
  end
end

control 'control-groups-entry-units-01' do
  impact 0.7
  title 'Systemd units are created for runtime management'

  describe file('/etc/systemd/system/cgconfig.service') do
    it { should exist }
  end

  describe file('/etc/systemd/system/cgred.service') do
    it { should exist }
  end
end
