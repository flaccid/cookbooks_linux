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

def generate_znc_password(password_plain)
  salt = `openssl rand -base64 20`.strip
  cmd = "echo -n '#{password_plain}#{salt}' | sha256sum | awk '{ print $1 }'"
  #cmd = "echo -n '#{password_plain}#{salt}' | openssl dgst -sha256 | awk '{ print $2 }'" 
  pass_hash = `#{cmd}`.strip
  pass = "sha256##{pass_hash.strip}##{salt.strip}#"
  return pass
end

# required
package "coreutils"

user node['znc']['system_user'] do
  comment "ZNC daemon"
  home "/home/#{node['znc']['system_user']}"
  shell "/bin/sh"
end

group node['znc']['system_group'] do
  members ['znc']
end

# set permissions on configuration files
[ node['znc']['data_dir'], 
  node['znc']['conf_dir'],
  node['znc']['module_dir'],
  node['znc']['users_dir']
].each do |dir|
  directory dir do
    owner node['znc']['system_user']
    group node['znc']['system_group']
    action :create
    recursive true
  end
end

# ensure znc pid file exists
file "#{node['znc']['pid_file']}" do
  owner node['znc']['system_user']
  group node['znc']['system_group']
  mode 0600
  action :create
end

# ensure serivice is installed and enabled
include_recipe "znc::install_service"

admin_password = generate_znc_password(node['znc']['admin_password'])

# render znc.conf
template "#{node['znc']['data_dir']}/configs/znc.conf" do
  source "znc.conf.erb"
  mode 0600
  owner node['znc']['system_user']
  group node['znc']['system_group']
  variables(
    :anon_ip_limit => node['znc']['anon_ip_limit'],
    :admin_server => "irc.freenode.net 6667",
    :bind_hosts => node['znc']['bind_hosts'],
    :connect_delay => node['znc']['connect_delay'],
    :global_modules => node['znc']['modules'],
    :max_buffer_size_list => "",
    :motd => node['znc']['motd'],
    :pid_file => node['znc']['pid_file'],
    :data_dir => node['znc']['data_dir'],
    :skin => node['znc']['skin'],
    :status_prefix => node['znc']['status_prefix'],
    :server_throttle => node['znc']['server_throttle'],
    :max_buffer_size => node['znc.max_buffer_size'],
    :port => node['znc']['port'],
    :user_name => node['znc']['admin_user'],
    :user_password => admin_password,
    :user_nickname => node['znc']['admin_user'],
    :user_nickname_alt => "#{node['znc']['admin_user']}_",
    :user_ident => node['znc']['admin_user'],
    :user_real_name => "ZNC Admin"
    #:users => users,
  )
  notifies :restart, "service[znc]", :delayed
end

# generate server SSL certificate
include_recipe "znc::generate_cert" unless File.exists?("#{node['znc']['data_dir']}/znc.pem")

# enable/disable modules
include_recipe "znc::modules"

# enable/start service
service "znc" do
  action [:enable, :start]
end