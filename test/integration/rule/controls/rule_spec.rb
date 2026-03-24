# frozen_string_literal: true

control 'control-groups-rule-config-01' do
  impact 1.0
  title 'Rule file is rendered'

  describe file('/etc/cgrules.conf') do
    it { should exist }
    its('content') { should match(/alice:stress-ng\tcpu,memory\tlimited/) }
  end
end

control 'control-groups-rule-config-02' do
  impact 0.7
  title 'Destination group exists in cgconfig'

  describe file('/etc/cgconfig.conf') do
    it { should exist }
    its('content') { should match(/group limited \{/) }
    its('content') { should match(/memory.max = 1048576;/) }
  end
end
