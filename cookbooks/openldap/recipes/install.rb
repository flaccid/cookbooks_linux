listen_host = ""
listen_host = "127.0.0.1" unless node[:openldap][:allow_remote] == "true"

listen_port = node[:openldap][:listen_port]

%w{slapd ldap-utils db4.2-util}.each do |p|
  package p
end

service "slapd" do
  action :nothing
end

template "/etc/default/slapd" do
  source "slapd.defaults.erb"
  variables( :listen_host => listen_host, :listen_port => listen_port)
  notifies :restart, resources(:service => "slapd"), :immediately
end

# TODO: Do we need to wait for slapd to come back here, like we do in the BASH script?

if node[:platform] == "ubuntu" && node[:platform_version] == "9.10"
  openldap_execute_ldif do
    source "ubuntu-karmic-9.10-fixRootDSE.ldif"
    type :remote_file
  end
end

openldap_set_config_admin_creds do
  cn node[:openldap][:config_admin_cn]
  password node[:openldap][:config_admin_password]
end

%w{back_bdb back_hdb}.each do |mod|
  openldap_module mod do
    action :enable
  end
end