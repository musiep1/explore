class sshdmn inherits sshdmn::params {
### set and control sshd_config with validation of the parameters ###

  # sshd_config changes are done against below processing file to be validated
  $proc_file = "${sshdmn::params::sshd_config}.puptmp"
  file {  $proc_file:
    ensure => file,
    source => $sshdmn::params::sshd_config,
  }

### Apply sshd configuration changes using augeas to the proc_file
  case $::osfamily {
    RedHat: {
      if $::operatingsystemmajrelease > 5 {
         augeas { "sshd_config_params":
           incl => "${proc_file}",
           lens => "Sshd.lns",
           context => "/files${proc_file}",
           ##context => "/files${sshdmn::params::sshd_config}",
           changes => [
                     "set MACs/1 hmac-sha1",
                     "set MACs/2 umac-64@openssh.com",
                     "set MACs/3 hmac-ripemd160",
                     "set Protocol 2",
                     "set PermitRootLogin without-password",
           ],
           ##notify  => Service[$sshdmn::params::service_name],
           ##notify => Exec['validate_ssh'],
         }

       } else {
         augeas { "sshd_config_params":
           incl => "${proc_file}",
           lens => "Sshd.lns",
           context => "/files${proc_file}",
           ##context => "/files${sshdmn::params::sshd_config}",
           changes => [
                     "set MACs/1 hmac-sha1",
                     "set MACs/2 hmac-ripemd160",
                     "set Protocol 2",
                     "set PermitRootLogin without-password",
           ],
           ##notify  => Service[$sshdmn::params::service_name],
           ##notify => Exec['validate_ssh'],
         }
       }

    }
    AIX: {
         augeas { "sshd_config_params":
           incl => "${proc_file}",
           lens => "Sshd.lns",
           context => "/files${proc_file}",
           ##context => "/files${sshdmn::params::sshd_config}",
           changes => [
                     "set MACs/1 hmac-sha2-256",
                     "set MACs/2 hmac-sha2-512",
                     "set MACs/3 hmac-sha1",
           ],
           ##notify  => Service[$sshdmn::params::service_name],
           ##notify => Exec['validate_ssh'],
         }
    }
    default: {
         augeas { "sshd_config_params":
           incl => "${proc_file}",
           lens => "Sshd.lns",
           context => "/files${proc_file}",
           ##context => "/files${sshdmn::params::sshd_config}",
           changes => [
                     "set MACs/1 hmac-sha1",
                     "set MACs/2 umac-64@openssh.com",
                     "set MACs/3 hmac-ripemd160",
                     "set Protocol 2",
                     "set PermitRootLogin without-password",
           ],
           ##notify  => Service[$sshdmn::params::service_name],
           ##notify => Exec['validate_ssh'],
         }
      ###fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
    }
  }

  ##exec { 'validate_ssh':
  ##  path => ['/usr/sbin', '/usr/bin', '/sbin'],
  ##  command      => "sshd -tf ${proc_file}",
  ##  require     => File[$proc_file],
  ##  refreshonly => true,
  ## }

### Validate configuration before replacing sshd_config file
  file { $sshdmn::params::sshd_config:
    ensure  => file,
    source  => $proc_file,
    mode => 600,
    owner => root,
    validate_cmd => "${sshdmn::params::sshd_exe} -tf %",
    ##require => Exec['validate_ssh'],
    notify  => Service[$sshdmn::params::service_name],
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

} # end class sshdmn

