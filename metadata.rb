name             'control_groups'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Provides and configures cgroups'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.6'
source_url       'https://github.com/sous-chefs/swap'
issues_url       'https://github.com/sous-chefs/swap/issues'
chef_version     '>= 13' if respond_to?(:chef_version)

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end
