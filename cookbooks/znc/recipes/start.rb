# Cookbook Name:: znc
# Recipe:: start
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

user_home = ::File.expand_path("~#{node.znc.user}")

directory "#{user_home}/.znc/logs" do
  owner node.znc.user
  group node.znc.group
  mode "0700"
end

file "#{user_home}/.znc/logs/znc.log" do
  owner node.znc.user
  group node.znc.group
  mode "0700"
end

execute "start_znc" do
  command "znc > ~/.znc/logs/znc.log 2>&1"
  user node.znc.user
end