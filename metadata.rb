name             'control_groups'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Provides and configures cgroups'
version          '0.2.13'
source_url       'https://github.com/sous-chefs/control_groups'
issues_url       'https://github.com/sous-chefs/control_groups/issues'
chef_version     '>= 13'

%w(ubuntu debian redhat centos suse opensuseleap scientific oracle amazon).each do |os|
  supports os
end
