class sshdmn::params {
  case $::osfamily {
    RedHat: {
      $server_package_name = 'openssh-server'
      $sshd_config = '/etc/ssh/sshd_config'
      $service_name = 'sshd'
      if $::operatingsystemmajrelease > 5 {
        $MACsString = 'MACs hmac-sha1,umac-64@openssh.com,hmac-ripemd160'
      } else {
        $MACsString = 'MACs hmac-sha1,hmac-ripemd160'
      }
    }

    AIX: {
      $server_package_name = 'openssh-server'
      $sshd_config = '/etc/ssh/sshd_config'
      $service_name = 'sshd'
      $MACsString = 'MACs hmac-sha2-256,hmac-sha2-512,hmac-sha1'
    }

    default: {
      $server_package_name = 'openssh-server'
      $sshd_config = '/etc/ssh/sshd_config'
      $service_name = 'sshd'
      $MACsString = 'MACs hmac-sha1,umac-64@openssh.com,hmac-ripemd160'
      ###fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
    }
  }

}
