node['control_groups']['packages'].each do |pkg_name|
  package pkg_name
end
