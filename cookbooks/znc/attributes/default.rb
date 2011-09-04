#
# Cookbook Name:: znc
# Attribute:: default
#
# Copyright 2011, Seth Chisamore
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set['znc']['system_user'] = 'znc'
set['znc']['system_group'] = 'znc'

default['znc']['user']            = "#{ENV['USER']}"
default['znc']['admin_user']      = 'znc-admin'
default['znc']['admin_password']  = nil

default['znc']['install_method']  = 'package'
default['znc']['data_dir']        = '/home/znc/.znc'
default['znc']['conf_dir']        = "#{znc['data_dir']}/configs"
default['znc']['log_dir']         = "#{znc['data_dir']}/moddata/adminlog"
default['znc']['module_dir']      = "#{znc['data_dir']}/modules"
default['znc']['users_dir']       = "#{znc['data_dir']}/users"

default['znc']['motd']            = "Welcome to ZNC!"
default["znc"]["pid_file"]        = "/var/run/znc.pid"
default['znc']['anon_ip_limit']   = "2"
default['znc']['bind_hosts']      = "0.0.0.0"
default['znc']['connect_delay']   = "3"
default['znc']['port']            = "+7777"
default['znc']['skin']            = "dark-clouds"
default['znc']['max_buffer_size'] = 500
default['znc']['modules']         = %w{ webadmin adminlog }
default['znc']['users']           = %w{ znc }

default['znc']['status_prefix']   = 'znc'
default['znc']['server_throttle'] = '3'

default['znc']['debug']               = false
default['znc']['foreground']          = false
default['znc']['use_screen_session']  = false

default['znc']['create_user']         = false