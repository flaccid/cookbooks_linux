#svn export http://framework.zend.com/svn/framework/standard/branches/release-1.11/library

include_recipe "php5::default"

zend_dl_uri="http://framework.zend.com/releases/ZendFramework-#{node[:zendframework][:version]}/ZendFramework-#{node[:zendframework][:version]}-minimal.tar.gz"
Chef::Log.info("About to install Zend Framework, requested version is #{node[:zendframework][:version]}, resulting in a URL request of #{zend_dl_uri}")

gzipfile="/tmp/zf.tar.gz"

file gzipfile do
  backup nil
  action :nothing
end

directory node[:zendframework][:library_path] do
  recursive true
  action :create
end

# Using remote file is just not doing the trick, gonna go old school
#remote_file gzipfile do
#  source zend_dl_uri
#  backup nil
#  action :create
#end

bash "Downloading Zend Framework #{node[:zendframework][:version]}" do
  code "wget -O #{gzipfile} #{zend_dl_uri}"
end

bash "Unzip zf to it's home" do
  code "tar --strip-components 1 -zxf #{gzipfile} -C #{node[:zendframework][:library_path]}"
  notifies :delete, resources(:file => gzipfile), :immediately
end

template "/etc/php5/conf.d/zendframework.ini" do
  source "zendframework.ini.erb"
end