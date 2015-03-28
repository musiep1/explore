class sshdmn inherits sshdmn::params {
  file { $sshdmn::params::sshd_config:
      ensure => present,
      mode => 600,
  }

### Apply sshd configuration changes using augeas
  case $::osfamily {
    RedHat: {
      if $::operatingsystemmajrelease > 5 {
         augeas { "sshd_config_params":
           context => "/files${sshdmn::params::sshd_config}",
           changes => [
                     "set MACs/1 hmac-sha1",
                     "set MACs/2 umac-64@openssh.com",
                     "set MACs/3 hmac-ripemd160",
                     "set Protocol 2",
                     "set PermitRootLogin without-password",
           ],
           notify  => Service[$sshdmn::params::service_name],
         }

       } else {
         augeas { "sshd_config_params":
           context => "/files${sshdmn::params::sshd_config}",
           changes => [
                     "set MACs/1 hmac-sha1",
                     "set MACs/2 hmac-ripemd160",
                     "set Protocol 2",
                     "set PermitRootLogin without-password",
           ],
           notify  => Service[$sshdmn::params::service_name],
         }
       }

    }
    AIX: {
         augeas { "sshd_config_params":
           context => "/files${sshdmn::params::sshd_config}",
           changes => [
                     "set MACs/1 hmac-sha2-256",
                     "set MACs/2 hmac-sha2-512",
                     "set MACs/3 hmac-sha1",
           ],
           notify  => Service[$sshdmn::params::service_name],
         }
    }
    default: {
         augeas { "sshd_config_params":
           context => "/files${sshdmn::params::sshd_config}",
           changes => [
                     "set MACs/1 hmac-sha1",
                     "set MACs/2 umac-64@openssh.com",
                     "set MACs/3 hmac-ripemd160",
                     "set Protocol 2",
                     "set PermitRootLogin without-password",
           ],
           notify  => Service[$sshdmn::params::service_name],
         }
      ###fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
    }
  }

### make sure sshd service running
  service { $sshdmn::params::service_name:
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    subscribe =>  File[$sshdmn::params::sshd_config],
  }

### make sure software package installed
  package { $sshdmn::params::server_package_name:
    ensure => present,
    before => File[$sshdmn::params::sshd_config],
  }
}
