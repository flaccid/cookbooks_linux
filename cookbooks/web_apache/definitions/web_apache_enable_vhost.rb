define :web_apache_enable_vhost, :fqdn => nil, :aliases => nil do
  fqdn = params[:fqdn]
  aliases = params[:aliases]
  docroot = "#{node[:web_apache][:content_dir]}/#{fqdn}/htdocs"

  # A workaround for a bug in RightScale's implementation of chef, where exluded optional
  # attributes cause all attributes to be nil.  This allows the user to provide a value
  # for the optional input which will be ignored.
  # RightScale ticket #101228-000015
  aliases = "" if aliases = "blank"

  Chef::Log.info "Setting up vhost for fqdn (#{fqdn})"

  # Create the sites new home
  directory docroot do
    mode 0775
    owner "www-data"
    group "www-data"
    recursive true
    action :create
  end

  # Create a directory for extending the vhost config
  directory "/etc/apache2/sites-available/#{fqdn}.d"


  web_app fqdn do
    cookbook "web_apache"
    server_aliases aliases
    docroot docroot
  end

  right_link_tag "apache2:vhost=#{fqdn}"
end