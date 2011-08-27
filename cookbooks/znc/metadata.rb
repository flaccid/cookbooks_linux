maintainer       "Chris Fordham"
maintainer_email "chris.fordham@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures ZNC IRC bouncer."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "build-essential"

%w{ debian ubuntu }.each do |os|
  supports os
end

recipe "znc::default","Install and configure ZNC."
recipe "znc::install","Install ZNC."
recipe "znc::start","Starts the ZNC daemon."
recipe "znc::stop","Stops the ZNC daemon."
recipe "znc::restart","Restarts the ZNC daemon."
recipe "znc::install_service","Installs the ZNC service."
recipe "znc::configure","Configures the ZNC main configuration."
recipe "znc::add_user","Add a ZNC user."
recipe "znc::change_user_password","Changes a ZNC user's password."
recipe "znc::modules","Enables desired ZNC modules."
recipe "znc::module_colloquy","Install and enable Colloquy ZNC module."
recipe "znc::package","Installs ZNC from package."
recipe "znc::source","Installs ZNC from source."
recipe "znc::generate_cert","Generates x509 certificate for ZNC."

attribute "znc/user",
  :display_name => "ZNC System User",
  :description => "The name of the system user under which ZNC will be run.",
  :default => "znc",
  :recipes => ["znc::default", "znc::install", "znc::generate_cert"]
  
attribute "znc/group",
  :display_name => "ZNC System Group",
  :description => "The name of the system group under which ZNC will be run",
  :default => "znc",
  :recipes => ["znc::default", "znc::install", "znc::generate_cert"]
  
attribute "znc/data_dir",
  :display_name => "ZNC Data Dir",
  :description => "Directory where ZNC data will be stored",
  :default => "/etc/znc",
  :recipes => ["znc::default", "znc::configure", "znc::generate_cert"]
  
attribute "znc/conf_dir",
  :display_name => "ZNC Config Dir",
  :description => "Directory where ZNC configuration will be stored",
  :default => "/etc/znc/configs",
  :recipes => ["znc::default", "znc::install"]
  
attribute "znc/log_dir",
  :display_name => "ZNC Log Dir",
  :description => "Directory where ZNC logs will be stored",
  :default => "/var/log/znc",
  :recipes => ["znc::default", "znc::install"]

attribute "znc/module_dir",
  :display_name => "ZNC Module Dir",
  :description => "Directory where ZNC modules will be stored",
  :default => "/etc/znc/modules",
  :recipes => ["znc::default", "znc::modules", "znc:module_colloquy"]
  
attribute "znc/user_dir",
  :display_name => "ZNC User Dir",
  :description => "Directory where ZNC users will be stored",
  :default => "/etc/znc/users",
  :recipes => ["znc::default", "znc::install", "znc::generate_cert"]
  
attribute "znc/install_method",
  :display_name => "ZNC Install Method",
  :description => "The installation source for znc, either source or package",
  :choice => ["package","source"],
  :default => "package",
  :recipes => ["znc::install"]
    
attribute "znc/modules_enabled",
  :display_name => "ZNC Modules Enabled",
  :description => "The ZNC modules to enable globally.",
  :default => "admin",
  :recipes => ["znc::modules"]

attribute "znc/debug",
  :display_name => "ZNC Debug Mode",
  :description => "Enable/disable debugging of ZNC service start and process.",
  :default => 'no',
  :choice => ['yes', 'no'],
  :recipes => ["znc::configure"]
  
attribute "znc/foreground",
  :display_name => "ZNC Foreground Mode",
  :description => "Enable/disable foreground of the ZNC service process.",
  :default => 'no',
  :choice => ['yes', 'no'],
  :recipes => ["znc::install"]
  
attribute "znc/use_screen_session",
  :display_name => "ZNC Run in Screen",
  :description => "Enable/disable starts/stops of the ZNC service in a screen session.",
  :default => 'no',
  :choice => ['yes', 'no'],
  :recipes => ["znc::install"]