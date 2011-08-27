# Cookbook Name:: znc
# Recipe:: default
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

# install znc
include_recipe "znc::install"

# install znc service
include_recipe "znc::install_service"

# configure znc
include_recipe "znc::configure"

# set permissions on configuration files
user node['znc']['user']

group node['znc']['group']
[ node['znc']['data_dir'], 
  node['znc']['conf_dir'],
  node['znc']['module_dir'],
  node['znc']['users_dir']
].each do |dir|
  directory dir do
    owner node['znc']['user']
    group node['znc']['group']
  end
end

# generate server SSL certificate
include_recipe "znc::generate_cert"

# add a znc user
#include_recipe "znc::add_user"

# enable/disable modules
include_recipe "znc::modules"