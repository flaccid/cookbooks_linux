<User <%= u['znc']['nick'] || u['id']  %>>
	Pass = <%= u['znc']['pass'] %>
	Nick = <%= u['znc']['nick'] || u['id'] %>
	AltNick = <%= u['znc']['alt_nick'] || "#{u['id']}_" %>
	Ident = <%= u['znc']['ident'] %>
	RealName = <%= u['znc']['real_name'] || u['comment'] %>
	QuitMsg = <%= u['znc']['quit_msg'] || 'ZNC (managed by Opscode Chef)' %>
	ChanModes = <%= u['znc']['chan_modes'] || '+stn' %>
	Buffer = <%= u['znc']['buffer'] || 50 %>
	KeepBuffer = <%= u['znc']['keep_buffer'] || false %>
	MultiClients = true
	BounceDCCs = true
	DenyLoadMod = false
	Admin = true
	DenySetBindHost = false
	DCCLookupMethod = default
	TimestampFormat = [%H:%M:%S]
	AppendTimestamp = false
	PrependTimestamp = true
	TimezoneOffset = <%= u['znc']['timezone_offset'] || '0.00' %>
	JoinTries = 10
	MaxJoins = 5
	IRCConnectEnabled = true

	Allow = *

  <% u['znc']['modules'].each do |mod,params| -%>
	LoadModule = <%= "#{mod} #{params}".strip  %>
  <% end -%>

	Server = <%= u['znc']['server'] %>
<% u['znc']['channels'].each do |chan,options| -%>

	<Chan <%= chan %>>
	</Chan>
<% end -%>
</User>