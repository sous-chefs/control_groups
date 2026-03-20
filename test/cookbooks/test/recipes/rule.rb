# frozen_string_literal: true

control_groups_install 'default' do
  manage_runtime false
end

control_groups_entry 'limited' do
  cpu('cpu.max' => '10000 100000')
  memory('memory.max' => '1048576')
  manage_runtime false
end

control_groups_rule 'alice' do
  command 'stress-ng'
  controllers %w(cpu memory)
  destination 'limited'
  manage_runtime false
end
