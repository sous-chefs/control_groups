name             'control_groups'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Provides and configures cgroups'

version          '0.1.6'
source_url       'https://github.com/sous-chefs/swap'
issues_url       'https://github.com/sous-chefs/swap/issues'
chef_version     '>= 13'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end
