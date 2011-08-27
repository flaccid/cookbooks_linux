# Cookbook Name:: znc
# Recipe:: configure
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

if !Chef::Config.solo
  users = search(:users, 'groups:znc')
else
  users = node[:znc][:users]
end

# set permissions on configuration files

user node['znc']['user']

group node['znc']['group']

[ node['znc']['data_dir'], 
  node['znc']['conf_dir'],
  node['znc']['module_dir'],
  node['znc']['users_dir']
].each do |dir|
  directory dir do
    owner node['znc']['system_user']
    group node['znc']['system_group']
  end
end

service "znc"

pass_plain = node.znc.admin_password
salt = `openssl rand -base64 20`
cmd = "echo -n \"#{pass_plain}#{salt}\" | openssl dgst -sha256" 
pass_hash = `#{cmd}`
pass = "sha256##{pass_hash}##{salt}#"

# render znc.conf
template "#{node.znc.data_dir}/configs/znc.conf" do
  source "znc.conf.erb"
  mode 0600
  owner node.znc.system_user
  group node.znc.system_group
  variables(
    :admin_user => node.znc.admin_user,
    :admin_password => "#{pass}",
    :admin_server => "irc.freenode.net 6667"
    :users => users,  
    :modules => node.znc.modules,
    :data_dir => node.znc.data_dir,
    :skin => node.znc.skin,
    :max_buffer_size => node.znc.max_buffer_size,
    :port => node.znc.port
  )
  notifies :start, "service[znc]", :immediately
end