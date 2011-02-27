maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "All rights reserved"
description      "Installs/Configures php5, pear, and smarty"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "apache2"

recipe "php5::default", "Performs the installation of php5, pear, the php5 module for apache, and the smarty template library.  Additional modules can be specified at runtime"
recipe "php5::fpm", "Installs the PHP-FPM FastCGI manager"

supports "ubuntu"

attribute "php5",
  :display_name => "php5 hash",
  :description => "php5",
  :type => "hash"

attribute "php5/module_list",
  :display_name => "PHP5 Module List",
  :description => "A list of PHP5 modules to install, separated by spaces. Only supply the module name appearing after php5-.  For instance if you wanted php5-mysql and php5-imap installed, this list should be set to \"mysql imap\".  To view a full list of available php5 modules see the Ubuntu package page http://packages.ubuntu.com/search?searchon=names&keywords=php5- ",
  :default => "",
  :recipes => ["php5::default"],
  :type => "string"

attribute "php5/server_usage",
  :display_name => "Server Usage",
  :description => "* dedicated (where the php-fpm config file allocates all existing resources of the machine)\n* shared (where the php-fpm config file is configured to use less resources so that it can be run concurrently with other apps like MySQL for example)",
  :recipes => [ "php5::fpm" ],
  :choice => ["shared", "dedicated"],
  :default => "dedicated"