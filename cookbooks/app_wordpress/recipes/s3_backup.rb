#
# Cookbook Name:: app_wordpress
# Recipe:: s3_backup
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

wpgzip="/tmp/wordpress.tar.gz"

app_wordpress_site node[:web_apache][:vhost_fqdn] do
  fqdn node[:web_apache][:vhost_fqdn]
  backup_file_path wpgzip
  action :backup
end

rjg_aws_s3 "Push backup to S3" do
  access_key_id node[:aws][:access_key_id]
  secret_access_key node[:aws][:secret_access_key]
  s3_bucket node[:app_wordpress][:s3_bucket]
  s3_file_prefix "#{node[:web_apache][:vhost_fqdn]}-wordpress"
  s3_file_extension ".tar.gz"
  file_path wpgzip
  history_to_keep Integer(node[:app_wordpress][:backup_history_to_keep])
  action :put
end