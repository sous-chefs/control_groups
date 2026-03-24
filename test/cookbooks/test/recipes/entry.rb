# frozen_string_literal: true

control_groups_install 'default' do
  manage_runtime false
end

control_groups_entry 'analytics' do
  cpu('cpu.max' => '20000 100000')
  extra_config('notify_on_release' => '1')
  manage_runtime false
end
