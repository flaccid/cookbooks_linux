# Cookbook Name:: znc
# Recipe:: configure_user
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

if node.platform != 'mac_os_x'
  package "coreutils" do
    action :install
  end
end

user node.znc.user do
  action :nothing
end

group node.znc.user

cmd = "sudo -u #{node.znc.user} echo -n \"$HOME\""
user_home = `#{cmd}`

directory "#{user_home}/.znc/configs" do
  owner node.znc.user
  group node.znc.group
  mode "0750"
  action :create
  recursive true
end

pass_plain = node.znc.user_password
salt = `openssl rand -base64 20`
if node.platform == 'mac_os_x'
  cmd = "echo -n '#{pass_plain}#{salt}' | openssl dgst -sha256 | awk '{ print $2 }'" 
else
  cmd = "echo -n '#{pass_plain}#{salt}' | sha256sum | awk '{ print $1 }'"
end
pass_hash = `#{cmd}`
pass = "sha256##{pass_hash}##{salt}#"

# render znc.conf
template "#{user_home}/.znc/configs/znc.conf" do
  source "znc.conf.erb"
  mode 0600
  owner node.znc.user
  group node.znc.group
  variables(
    :create_user => node.znc.create_user,
    :user_name => node.znc.user,
    :user_ident => node.znc.user_ident,
    :user_real_name => node.znc.user_real_name,
    :user_password => "#{pass}",
    :user_nickname => node.znc.user_nickname,
    :user_nickname_alt => node.znc.user_nickname_alt,
    :user_default_channel => node.znc.user_default_channel,
    :anon_ip_limit => node.znc.anon_ip_limit,
    :admin_user => node.znc.admin_user,
    :admin_password => "#{pass}",
    :admin_server => "irc.freenode.net 6667",
    :bind_hosts => node.znc.bind_hosts,
    :connect_delay => node.znc.connect_delay,
    #:users => users,
    :global_modules => node.znc.modules,
    :max_buffer_size_list => "",
    :motd => node.znc.motd,
    :default_server => node.znc.default_server,
    :pid_file => node.znc.pid_file,
    :data_dir => node.znc.data_dir,
    :skin => node.znc.skin,
    :status_prefix => node.znc.status_prefix,
    :server_throttle => node.znc.server_throttle,
    :max_buffer_size => node.znc.max_buffer_size,
    :port => node.znc.port
  )
#  notifies :restart, "service[znc]", :immediately
end

# ensure znc pid file exists
file "#{node.znc.pid_file}" do
  owner node.znc.user
  group node.znc.group
  mode 0600
  action :create
end

#todo: only call if no cert exists
# generate server SSL certificate
#include_recipe "znc::generate_cert"

# enable/disable modules
include_recipe "znc::modules"