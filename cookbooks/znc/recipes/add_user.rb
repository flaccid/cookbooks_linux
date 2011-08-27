# Cookbook Name:: znc
# Recipe:: add_user
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

require json

users = null

if !Chef::Config.solo
  users = search(:users, 'groups:znc')
else
  users = JSON.parse(node[:znc][:users])
end
Chef::Log.info('ZNC Users: '+users.inspect)

if users
 
end