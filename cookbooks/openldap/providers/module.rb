action :enable do
  Chef::Log.info("Enabling OpenLDAP module (#{new_resource.name})")
  unless `ldapsearch -Q -Y EXTERNAL -H ldapi:/// -b cn=config "(&(objectClass=olcModuleList)(olcModuleLoad=#{new_resource.name}))"` =~ /numEntries/
    # TODO: Fairly certain that I can get away without the index here, and anywhere else I use in for cn=config stuff.
    idx = `ldapsearch -Q -Y EXTERNAL -H ldapi:/// -b cn=config "(objectClass=olcModuleList)" | grep numEntries | cut -d' ' -f3`
    idx = 0 unless idx

    openldap_execute_ldif do
      executable "ldapadd"
      source "addModule.ldif.erb"
      source_type :template
      idx idx
      module_name new_resource.name
    end
  end
end