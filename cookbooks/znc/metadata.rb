maintainer       "Chris Fordham"
maintainer_email "chris.fordham@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures ZNC IRC bouncer."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "build-essential"

%w{ debian ubuntu mac_os_x }.each do |os|
  supports os
end

recipe "znc::default","Install and configure ZNC."
recipe "znc::install","Install ZNC."
recipe "znc::start","Starts the ZNC daemon."
recipe "znc::stop","Stops the ZNC daemon."
recipe "znc::restart","Restarts the ZNC daemon."
recipe "znc::install_service","Installs the ZNC service."
recipe "znc::install_from_git_devel","Installs ZNC from the git-devel source at GitHub."
recipe "znc::install_from_nightly","Installs the nightly source snapshot of ZNC."
recipe "znc::install_from_source_tarball","Installs ZNC from remote source tarball."
recipe "znc::install_from_package","Installs ZNC from package."
recipe "znc::uninstall_package","Uninstalls ZNC from package."
recipe "znc::uninstall_git_devel","Uninstalls ZNC from git-devel."
recipe "znc::configure","Configures the ZNC main configuration."
recipe "znc::add_user","Add a ZNC user."
recipe "znc::change_user_password","Changes a ZNC user's password."
recipe "znc::modules","Enables desired ZNC modules."
recipe "znc::module_colloquy","Install and enable Colloquy ZNC module."
recipe "znc::source","Installs ZNC from source."
recipe "znc::generate_cert","Generates x509 certificate for ZNC."
recipe "znc::backup_config","Backup the ZNC configuration to Git or S3."
recipe "znc::restore_config","Restore the ZNC configuration to Git or S3."

attribute "znc/configure_options",
  :display_name => "ZNC Compile Options",
  :description => "./configure options for ZNC.",
  :default => "",
  :recipes => ["znc::source"]
  
attribute "znc/source_tarball",
  :display_name => "ZNC Source Tarball",
  :description => "The ZNC source tarball from http://znc.in/releases/",
  :default => "znc-latest.tar.gz",
  :recipes => ["znc::install_from_source_tarball"]

attribute "znc/anon_ip_limit",
  :display_name => "ZNC Anonymous IP Limit",
  :description => "Limits the number of unidentified connections per IP with ZNC.",
  :default => "2",
  :recipes => ["znc::configure"]

attribute "znc/bind_hosts",
  :display_name => "ZNC Bind Host",
  :description => "This is a list of allowed bindhosts for ZNC.",
  :default => "127.0.0.1",
  :recipes => ["znc::configure"]

attribute "znc/connect_delay",
  :display_name => "ZNC Connect Delay",
  :description => "The time every connection will be delayed, in seconds. Some servers refuse your connection if you reconnect too fast. This affects the connection between ZNC and the IRC server; not the connection between your IRC client and ZNC.",
  :default => "3",
  :recipes => ["znc::configure"]

attribute "znc/pid_file",
  :display_name => "ZNC PID File",
  :description => "The PID file for ZNC.",
  :default => "/var/lib/znc.pid",
  :recipes => ["znc::configure"]

attribute "znc/motd",
  :display_name => "ZNC MOTD",
  :description => "The 'message of the day' which is sent to clients on connect via notice from *status. Can be specified multiple times.",
  :default => "Welcome to ZNC.",
  :recipes => ["znc::configure"]

attribute "znc/server_throttle",
  :display_name => "ZNC Server Throttle",
  :description => "The time between two connect attempts to the same hostname to ZNC.",
  :default => "3",
  :recipes => ["znc::configure"]

attribute "znc/status_prefix",
  :display_name => "ZNC Status Prefix",
  :description => "The prefix for the status and module queries. This setting may be overwritten by users.",
  :recipes => ["znc::configure"]

attribute "znc/admin_user",
  :display_name => "ZNC Admin User",
  :description => "The name of the ZNC admin user.",
  :default => "znc-admin",
  :recipes => ["znc::configure"]
  
attribute "znc/admin_password",
  :display_name => "ZNC Admin Password",
  :description => "The password of the ZNC admin user.",
  :required => "required",
  :recipes => ["znc::configure"]

attribute "znc/system_user",
  :display_name => "ZNC System User",
  :description => "The name of the system user under which ZNC will be run.",
  :default => "znc",
  :recipes => ["znc::configure", "znc::generate_cert"]
  
attribute "znc/system_group",
  :display_name => "ZNC System Group",
  :description => "The name of the system group under which ZNC will be run",
  :default => "znc",
  :recipes => ["znc::configure", "znc::generate_cert"]
  
attribute "znc/data_dir",
  :display_name => "ZNC Data Dir",
  :description => "Directory where ZNC data will be stored",
  :default => "/etc/znc",
  :recipes => ["znc::configure", "znc::generate_cert"]
  
attribute "znc/conf_dir",
  :display_name => "ZNC Config Dir",
  :description => "Directory where ZNC configuration will be stored",
  :default => "/etc/znc/configs",
  :recipes => ["znc::configure"]
  
attribute "znc/log_dir",
  :display_name => "ZNC Log Dir",
  :description => "Directory where ZNC logs will be stored",
  :default => "/var/log/znc",
  :recipes => ["znc::configure"]

attribute "znc/module_dir",
  :display_name => "ZNC Module Dir",
  :description => "Directory where ZNC modules will be stored",
  :default => "/etc/znc/modules",
  :recipes => ["znc::configure", "znc::modules", "znc:module_colloquy"]
  
attribute "znc/user_dir",
  :display_name => "ZNC User Dir",
  :description => "Directory where ZNC users will be stored",
  :default => "/etc/znc/users",
  :recipes => ["znc::configure", "znc::generate_cert"]
  
attribute "znc/install_service",
  :display_name => "ZNC Install Method",
  :description => "The installation source for znc, either source or package",
  :choice => ["package", "source", "git_devel", "source_tarball", "nightly", "freebsd_package", "freebsd_port", "homebrew", "mac_ports", "pacman"],
  :default => "source_tarball",
  :recipes => ["znc::install"]
    
#attribute "znc/modules",
#  :display_name => "ZNC Modules Enabled",
#  :description => "The ZNC modules to enable globally.",
#  :default => "admin",
#  :recipes => ["znc::configure", "znc::modules"]

attribute "znc/debug",
  :display_name => "ZNC Debug Mode",
  :description => "Enable/disable debugging of ZNC service start and process.",
  :default => 'no',
  :choice => ['yes', 'no'],
  :recipes => ["znc::configure", "znc::install_service"]
  
attribute "znc/foreground",
  :display_name => "ZNC Foreground Mode",
  :description => "Enable/disable foreground of the ZNC service process.",
  :default => 'no',
  :choice => ['yes', 'no'],
  :recipes => ["znc::install_service"]
  
attribute "znc/use_screen_session",
  :display_name => "ZNC Run in Screen",
  :description => "Enable/disable starts/stops of the ZNC service in a screen session.",
  :default => 'no',
  :choice => ['yes', 'no'],
  :recipes => ["znc::install_service"]
  
attribute "znc/users",
  :display_name => "ZNC Users",
  :description => "Initial users to create when configuring ZNC.",
  :default => 'znc',
  :recipes => ["znc::configure"]
  
attribute "znc/max_buffer_size",
  :display_name => "ZNC Max Buffer Size",
  :description => "ZNC maximum buffer size.",
  :default => '500',
  :choice => ['500', '1024'],
  :recipes => ["znc::configure"]
  
attribute "znc/port",
  :display_name => "ZNC IPv4 Listen Port",
  :description => "ZNC daemon listen port.",
  :default => '+7777',
  :choice => ['+7777'],
  :recipes => ["znc::configure"]

attribute "znc/skin",
  :display_name => "ZNC Skin",
  :description => "ZNC skin.",
  :default => "dark-clouds",
  :choice => ["dark-clouds"],
  :recipes => ["znc::configure"]