# Cookbook Name:: znc
# Recipe:: install_git_devel
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

include_recipe 'build-essential'

execute 'build-znc-gitsrc' do
  command "cd /usr/src/znc/znc; ./configure; make"
  action :nothing
  #environment ({'HOME' => '/home/myhome'})
end

execute 'install-znc-gitsrc' do
  command "cd /usr/src/znc/znc; make install"
  creates "/usr/local/znc"
  action :nothing
end

git '/usr/src/znc' do
  repository "git://github.com/znc/znc.git"
  reference "master"
  action :sync
  notifies :run, resources(:execute => "build-znc-gitsrc"), :immediately
  notifies :run, resources(:execute => "install-znc-gitsrc"), :delayed
end