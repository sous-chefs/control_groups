# frozen_string_literal: true

control 'control-groups-packages-01' do
  impact 1.0
  title 'Required packages are installed'

  %w(cgroup-tools libcgroup2 libpam-cgroup).each do |package_name|
    describe package(package_name) do
      it { should be_installed }
    end
  end
end

control 'control-groups-config-01' do
  impact 1.0
  title 'Configuration files are rendered'

  describe file('/etc/cgconfig.conf') do
    it { should exist }
    its('content') { should match(/group limited \{/) }
    its('content') { should match(/cpu.max = 10000 100000;/) }
    its('content') { should match(/memory.max = 1048576;/) }
  end

  describe file('/etc/cgrules.conf') do
    it { should exist }
    its('content') { should match(/alice:stress-ng\tcpu,memory\tlimited/) }
  end
end

control 'control-groups-services-01' do
  impact 0.7
  title 'Systemd units are present for runtime management'

  %w(cgconfig cgred).each do |service_name|
    describe file("/etc/systemd/system/#{service_name}.service") do
      it { should exist }
    end
  end
end
