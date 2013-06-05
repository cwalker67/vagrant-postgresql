class refresh {
   exec { "apt update":
       command => "/usr/bin/apt-get -y update"
   }
}

stage { pre: before => Stage[main] }
 
# Forces the repository to be configured before any other task
class { 'refresh': stage => pre }

class { 'postgresql::server':
  config_hash => {
    'ip_mask_deny_postgres_user' => '0.0.0.0/32',
    'ip_mask_allow_all_users'    => '0.0.0.0/0',
    'listen_addresses'           => '*',
    'postgres_password'          => 'postgres',
  },
}

postgresql::db { 'testdb':
    user     => 'dbuser',
    password => 'dbpassword'
}