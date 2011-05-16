include_recipe "nginx::default"
include_recipe "php5::fpm"
include_recipe "php5::fpmenable_nginx"

# Load the nginx plugin in the main config file
node[:rs_utils][:plugin_list] += " curl_json" unless node[:rs_utils][:plugin_list] =~ /curl/
node[:rs_utils][:process_list] += " php5-fpm" unless node[:rs_utils][:process_list] =~ /php5-fpm/

nginx_conf = ::File.join(node[:nginx][:dir], "sites-available", "#{node[:hostname]}.d", "php5-fpm-stats.conf")
nginx_collectd_conf = ::File.join(node[:rs_utils][:collectd_plugin_dir], "php5-fpm.conf")

listen_str = node[:php5_fpm][:listen] == "socket" ? node[:php5_fpm][:listen_socket] : "#{node[:php5_fpm][:listen_ip]}:#{node[:php5_fpm][:listen_port]}"

# This is necessary for collectd's curl_json plugin, but apparently not installed already *shrug*
package "libyajl1"

file nginx_conf do
  content <<-EOF
location /fpm_status {
  access_log off;
  fastcgi_pass #{listen_str};
}
  EOF
  notifies :restart, resources(:service => "nginx"), :immediately
  action :create
end

template nginx_collectd_conf do
  source "php5-fpm-collectd.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "collectd"), :immediately
end