# Cookbook Name:: znc
# Recipe:: install_from_source_tarball
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

# Official source tarballs can be found at http://znc.in/releases/
# If you want to compile ZNC with OpenSSL support, you need the OpenSSL development package. On Debian/Ubuntu this is called libssl-dev, on CentOS/Fedora/Red Hat it's openssl-devel. 
# Please note that compiling can take 5-10mins or more. 
# See the FAQ page if you encounter problems, http://wiki.znc.in/FAQ

# latest source tarball (at this time) http://znc.in/releases/znc-0.206.tar.gz

# remove znc if installed by package or git-devel
log "Removing ZNC by package and git-devel if installed."
include_recipe "znc::uninstall_package"
include_recipe "znc::uninstall_git_devel"

directory "/usr/src/znc" do
  action :create
  recursive true
end

log "Fetching source tarball, http://znc.in/releases/#{node['znc']['source_tarball']}."
remote_file "/usr/src/znc/#{node['znc']['source_tarball']}" do
  source "http://znc.in/releases/#{node['znc']['source_tarball']}"
  mode "0644"
end

execute "build_and_install_from_source" do
  cwd "/usr/src/znc"
  #(use --prefix=$HOME/znc if you don't want a system wide installation or simply don't have root; use --with-openssl=/path/to/openssl if you have a non-standard SSL path)
  #(use --enable-extra to configure (and additionally --enable-tcl for modtcl) to include the whole extra package) 
  #( if you are on a dedicated server and your CPU has more than one core, you can use make -jX where X is the number of CPU cores to speed up compilation)
  command "cd znc-* && ./configure && make && make install"
  action :nothing
end

execute "extract_source_from_tarball" do
  cwd "/usr/src/znc"
  command "tar -zxf #{node['znc']['source_tarball']}"
  notifies :run, resources(:execute => 'build_and_install_from_source'), :immediately
end

# ln -s /usr/local/bin/znc /usr/bin/znc
link "/usr/bin/znc" do
  to "/usr/local/bin/znc"
end