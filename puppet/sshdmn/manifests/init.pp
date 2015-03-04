# == Class: sshdmn
#
# Full description of class sshdmn here.
#
# === Parameters
# MACsLine
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*MACsLine*]
# MAC (Message Authentication Code) algorithm(s) used for data integrity verification
# String of comma separated parameters
#
# === Examples
# MACs hmac-sha1,umac-64@openssh.com,hmac-ripemd160
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#

class sshdmn ( $MACsLine = $sshdmn::params::MACsString ) inherits sshdmn::params {
  file { $sshdmn::params::sshd_config:
      ensure => present,
      mode => 600,
  } ->
  file_line { $sshdmn::params::sshd_config:
      line => $MACsLine,
      match => '^MACs ', # must match line as well
      ensure => present,
      multiple => true,  # just in case you have same parameter listed multiple times - change all lines
      path => $sshdmn::params::sshd_config,
      notify  => Service[$sshdmn::params::service_name],
  }

  service { $sshdmn::params::service_name:
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    subscribe =>  File[$sshdmn::params::sshd_config],
  }

  package { $sshdmn::params::server_package_name:
    ensure => present,
    before => File[$sshdmn::params::sshd_config],
  }

}

