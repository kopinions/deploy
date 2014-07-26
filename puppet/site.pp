# class db{
# 	class { 'postgresql::server':
# 		postgres_password => 'twer',
# 		ip_mask_deny_postgres_user => '0.0.0.0/32',
# 		ip_mask_allow_all_users    => '0.0.0.0/0',
# 		listen_addresses           => '*'
# 	}
# 	postgresql::server::role { 'twer':
# 	  password_hash => postgresql_password('twer', 'twer'),
# 	}
# 	postgresql::server::db { 'order':
# 	  user     => 'twer',
# 	  password => postgresql_password('twer', 'twer'),
# 	}
# }


# include rvm

# rvm_system_ruby {
# 	'ruby-2.1':
# 		ensure      => 'present',
# 		default_use => true;
# }

# apt update
# class { 'apt':
#   always_apt_update    => false
# }

stage { 'preinstall':
  before => Stage['main']
}
 
class apt_get_update {
  exec { '/usr/bin/apt-get -y update ': }
}
 
class { 'apt_get_update':
  stage => preinstall
}

include apt

# class apt {
#   exec { "apt-update":
#     command => "/usr/bin/apt-get update"
#   }

#   # Ensure apt is setup before running apt-get update
#   Apt::Key <| |> -> Exec["apt-update"]
#   Apt::Source <| |> -> Exec["apt-update"]

#   # Ensure apt-get update has been run before installing any packages
#   Exec["apt-update"] -> Package <| |>
# }

# install git
# include git

include java8

# include mongodb

# class { 'nodejs':
#  version => 'v0.10.25',
# }
