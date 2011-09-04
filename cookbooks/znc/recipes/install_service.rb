# Cookbook Name:: znc
# Recipe:: install_service
#
# Copyright 2011, Chris Fordham
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

case node.platform
  when 'mac_os_x'
    # TODO: install via homebrew
    log "OS X not yet supported."
    exit()
end


# set permissions on configuration files
[ node.znc.data_dir, 
  node.znc.conf_dir,
  node.znc.module_dir,
  node.znc.users_dir
].each do |dir|
  directory dir do
    owner node.znc.system_user
    group node.znc.system_group
  end
end

user node.znc.system_user do
  comment "ZNC daemon"
end

group node.znc.system_group do
  members ['znc']
end

# install znc rc script
template "/etc/init.d/znc" do
  source "znc.init.#{node.platform}.erb"
  owner "root"
  group "root"
  mode "0755"	 	
end

service "znc" do
  supports :restart => true, :reload => false
  action :enable
end