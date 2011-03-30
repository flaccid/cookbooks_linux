#
# Cookbook Name:: ruby_enterprise
# Recipe:: default
#
#  Copyright 2011 Ryan J. Geyer
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

machines = {"x86_64" => "amd64", "i386" => "i386"}
arch = machines[node[:kernel][:machine]]
#arch = node[:architecture] == 'i386' ? node[:architecture] : 'amd64'
pkgname = "ruby-enterprise_#{node[:ruby_enterprise][:version]}_#{arch}_ubuntu10.04.deb"

bash "Download Ruby Enterprise" do
  code <<-EOF
wget -q -O http://rubyenterpriseedition.googlecode.com/files/#{pkgname} /tmp/#{pkgname}
dpkg -i /tmp/#{pkgname}
  EOF
end

#http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise_1.8.7-2011.03_amd64_ubuntu10.04.deb