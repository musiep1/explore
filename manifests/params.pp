class sshdmn::params {
  case $::osfamily {
    RedHat: {
      $server_package_name = 'openssh-server'
      $sshd_config = '/etc/ssh/sshd_config'
      $sshd_exe = '/usr/sbin/sshd'
      $service_name = 'sshd'
    }
    AIX: {
      $server_package_name = 'openssh-server'
      $sshd_config = '/etc/ssh/sshd_config'
      $sshd_exe = '/usr/sbin/sshd'
      $service_name = 'sshd'
    }
    default: {
      $server_package_name = 'openssh-server'
      $sshd_config = '/etc/ssh/sshd_config'
      $sshd_exe = '/usr/sbin/sshd'
      $service_name = 'sshd'
      ###fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
    }
  }
}
