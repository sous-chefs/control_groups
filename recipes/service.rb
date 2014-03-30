case node.platform
when 'amazon', 'centos', 'fedora', 'oracle', 'redhat', 'scientific'
  service 'cgconfig' do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
  end
when 'debian'
  service 'cgred' do
    supports :status => true, :start => true, :stop => true, :reload => true
    action [:enable, :start]
  end

  service 'cgconfig' do
    supports :status => true, :start => true, :stop => true, :reload => true
    ignore_failure true
    action [:enable, :start]
  end
when 'ubuntu'
  if node.platform_version == '12.04'
    service 'cgred' do
      supports :status => true, :start => true, :stop => true, :reload => true
      action :start
    end

    service 'cgconfig' do
      supports :status => true, :start => true, :stop => true, :reload => true
      ignore_failure true
      action :start
    end
  else
    service 'cgroup-lite' do
      action :start
    end
  end
end
