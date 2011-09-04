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

package "coreutils" do
  action :install
end

group node.znc.user

user node.znc.user do
  gid node.znc.user
  home "/home/#{node.znc.user}"
end

directory "/home/#{node.znc.user}/.znc/configs" do
  recursive true
end

pass_plain = node.znc.admin_password
salt = `openssl rand -base64 20`
cmd = "echo -n '#{pass_plain}#{salt}' | sha256sum | awk '{ print $1 }'"
#cmd = "echo -n '#{pass_plain}#{salt}' | openssl dgst -sha256 | awk '{ print $2 }'" 
pass_hash = `#{cmd}`
pass = "sha256##{pass_hash}##{salt}#"

# render znc.conf
template "#{node.znc.data_dir}/configs/znc.conf" do
  source "znc.conf.erb"
  mode 0600
  owner node.znc.system_user
  group node.znc.system_group
  variables(
    :create_user => node.znc.create_user,
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