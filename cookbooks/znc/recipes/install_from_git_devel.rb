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

# ensure pkg-config is installed
pkgconfig_pkg = value_for_platform(
  [ "debian","ubuntu" ] => {
    "default" => 'pkg-config'
  },
  [ "centos","rhel" ] => {
    "default" =>  'pkgconfig'
  },
    "default" => 'pkgconfig'
)
package pkgconfig_pkg

# sources don't share the same locations so this shouldn't be required
include_recipe 'znc::uninstall_package'

directory '/usr/local/src/znc-devel' do
  recursive true
  action :delete
end

directory '/usr/local/src/znc-devel' do
  action :create
end

execute 'install-znc-git-devel' do
  cwd "/usr/local/src/znc-devel"
  command "make install"
  action :nothing
end

execute 'build-znc-git-devel' do
  cwd "/usr/local/src/znc-devel"
  command "./bootstrap.sh && ./configure && make"
  action :nothing
  notifies :run, resources(:execute => 'install-znc-git-devel'), :immediately
end

git '/usr/local/src/znc-devel' do
  repository "git://github.com/znc/znc.git"
  reference 'master'
  action :sync
  notifies :run, resources(:execute => 'build-znc-git-devel'), :immediately  
end

# ln -s /usr/local/bin/znc /usr/bin/znc
link "/usr/bin/znc" do
  to "/usr/local/bin/znc"
  not_if "test -f /usr/bin/znc"
end