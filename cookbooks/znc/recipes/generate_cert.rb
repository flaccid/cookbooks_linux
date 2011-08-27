# Cookbook Name:: znc
# Recipe:: generate_cert
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

bash "generate-pem" do
  cwd node['znc']['data_dir']
  code <<-EOH
  umask 077
  openssl genrsa 2048 > znc.key
  openssl req -subj /C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{node['fqdn']}/emailAddress=znc@#{node['fqdn']} \
   -new -x509 -nodes -sha1 -days 3650 -key znc.key > znc.crt
  cat znc.key znc.crt > znc.pem
  EOH
  user node.znc.system_user
  group node.znc.system_group
  creates "#{node.znc.data_dir}/znc.pem"
end