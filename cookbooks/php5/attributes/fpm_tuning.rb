#case ec2[:instance_type]
#  when "t1.micro"
#    if (db_mysql[:server_usage] == :dedicated)
#      default[:php5_fpm][:tunable][:max_children] = 5
#      default[:php5_fpm][:tunable][:min_spare]    = 2
#      default[:php5_fpm][:tunable][:max_spare]    = 4
#    else
#      default[:php5_fpm][:tunable][:max_children] = 3
#      default[:php5_fpm][:tunable][:min_spare]    = 1
#      default[:php5_fpm][:tunable][:max_spare]    = 2
#    end
#  when "m1.small", "c1.medium"
#    if (db_mysql[:server_usage] == :dedicated)
#      default[:php5_fpm][:tunable][:max_children] = 15
#      default[:php5_fpm][:tunable][:min_spare]    = 5
#      default[:php5_fpm][:tunable][:max_spare]    = 10
#    else
#      default[:php5_fpm][:tunable][:max_children] = 7
#      default[:php5_fpm][:tunable][:min_spare]    = 3
#      default[:php5_fpm][:tunable][:max_spare]    = 5
#    end
#  when "m1.large", "c1.xlarge"
#    if (db_mysql[:server_usage] == :dedicated)
#      default[:php5_fpm][:tunable][:max_children] = 68
#      default[:php5_fpm][:tunable][:min_spare]    = 6
#      default[:php5_fpm][:tunable][:max_spare]    = 12
#    else
#      default[:php5_fpm][:tunable][:max_children] = 34
#      default[:php5_fpm][:tunable][:min_spare]    = 3
#      default[:php5_fpm][:tunable][:max_spare]    = 6
#    end
#  when "m1.xlarge"
#    if (db_mysql[:server_usage] == :dedicated)
#      default[:php5_fpm][:tunable][:max_children] = 136
#      default[:php5_fpm][:tunable][:min_spare]    = 12
#      default[:php5_fpm][:tunable][:max_spare]    = 24
#    else
#      default[:php5_fpm][:tunable][:max_children] = 64
#      default[:php5_fpm][:tunable][:min_spare]    = 6
#      default[:php5_fpm][:tunable][:max_spare]    = 12
#    end
#end

