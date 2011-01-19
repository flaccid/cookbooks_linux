maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "All rights reserved"
description      "Installs/Configures openldap"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

supports "ubuntu"

recipe "openldap::install", "Installs a basic, working OpenLDAP server daemon"

attribute "openldap/allow_remote",
  :display_name => "OpenLDAP Allow Remote?",
  :description => "A boolean indicating if the OpenLDAP server should accept remote connections or not",
  :choice => ["true", "false"],
  :required => "required",
  :recipes => ["openldap::install"]

attribute "openldap/listen_port",
  :display_name => "OpenLDAP listen port",
  :description => "The TCP/IP port the OpenLDAP server should listen on",
  :default => "389",
  :recipes => ["openldap::install"]

attribute "openldap/config_admin_cn",
  :display_name => "OpenLDAP Config Admin CN",
  :description => "The desired \"Common Name\" for the slapd configuration (cn=config) administrator",
  :required => "required",
  :recipes => ["openldap::install"]

attribute "openldap/config_admin_password",
  :display_name => "OpenLDAP Config Admin password",
  :description => "The desired password for the slapd configuration (cn=config) administrator",
  :required => "required",
  :recipes => ["openldap::install"]