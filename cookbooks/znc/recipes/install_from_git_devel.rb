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

# sources don't share the same locations so this shouldn't be required
#include_recipe 'znc::uninstall_package'

# ensure pkgconfig is installed
if node.platform != 'mac_os_x'
  package 'pkgconfig' do
    action :install
  end
end

directory '/usr/local/src/znc-devel' do
  recursive true
  action :delete
end

directory '/usr/local/src/znc-devel' do
  action :create
end

execute 'build-znc-git-devel' do
  command "rm -vf /usr/local/src/znc-devel/modules/partyline.cpp && cd /usr/local/src/znc-devel && ./bootstrap.sh && ./configure && make"
  action :nothing
end

execute 'install-znc-git-devel' do
  command "cd /usr/local/src/znc-devel; make install"
  action :nothing
end

git '/usr/local/src/znc-devel' do
  repository "git://github.com/znc/znc.git"
  reference 'master'
  action :sync
  notifies :run, resources(:execute => 'build-znc-git-devel'), :immediately
  notifies :run, resources(:execute => 'install-znc-git-devel'), :delayed
end

# ln -s /usr/local/bin/znc /usr/bin/znc
link "/usr/bin/znc" do
  to "/usr/local/bin/znc"
  not_if "test -f /usr/bin/znc"
end