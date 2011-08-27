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

service "znc"

if !Chef::Config.solo
  users = search(:users, 'groups:znc')
else
  users = node[:znc][:users]
end

# render znc.conf
template "#{node.znc.data_dir}/configs/znc.conf" do
  source "znc.conf.erb"
  mode 0600
  owner node.znc.user
  group node.znc.group
  variables(
    :users => users,  
    :modules => node.znc.modules
  )
  notifies :start, "service[znc]", :immediately
end