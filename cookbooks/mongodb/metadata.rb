maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Installs/Configures mongodb"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

supports "ubuntu"

recipe "mongodb::apt", "Installs mongodb from the net10 official packages"

attribute "mongodb/datadir",
  :display_name => "MongoDB Data Directory",
  :description => "The full path to the directory where mongodb should store it's data files",
  :recipes => ["mongodb::apt"],
  :required => "optional",
  :default => "/var/db/mongodb"

attribute "mongodb/logfile",
  :display_name => "MongoDB Log File",
  :description => "The full path to a file where MongoDB will write logs",
  :recipes => ["mongodb::apt"],
  :required => "optional",
  :default => "/var/log/mongodb.log"

attribute "mongodb/port",
  :display_name => "MongoDB Listen Port",
  :description => "Accept connections on the specified port",
  :recipes => ["mongodb::apt"],
  :required => "optional",
  :default => "27017"

attribute "mongodb/bind_ip",
  :display_name => "MongoDB Bind IP",
  :description => "Accept connections on the interface with the given IP, or 0.0.0.0 for all",
  :recipes => ["mongodb::apt"],
  :required => "optional",
  :default => "0.0.0.0"