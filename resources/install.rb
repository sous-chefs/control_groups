

action :install do
  package control_group_packages

  service 'cgred' do
    supports status: true, start: true, stop: true, reload: true
    action :nothing
  end

  service 'cgconfig' do
    supports status: true, start: true, stop: true, reload: true
    ignore_failure true
    action :nothing
  end



end

action_class do
  include Chef::ControlGroups::Helpers
end
