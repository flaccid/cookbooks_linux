# Cookbook Name:: znc
# Recipe:: makeconf_interactive_screen
#
# Copyright 2011, Chris Fordham
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

#include_recipe "screen::install"
#include_recipe "sudo::install"

log "Starting detached screen session for #{node.znc.user}."

execute "znc_makeconf_interactive" do
  # when screen -ls | grep is run at the end, if no screens exist a non-zero exit will be triggered
  command "sudo -u #{node.znc.user} screen -S znc -t znc -d -m -c /dev/null -- sh -c 'znc -f --makeconf && exit; exec $SHELL'; echo '==> screen sessions for #{node.znc.user}:'; screen -ls | grep znc"
end

log "==> Now, to start the interactive configuration, switch user to '#{node.znc.user}' and run, screen -r -S znc"