# == Class artifactory::install
#
# This class is called from artifactory for install.
#

include profile::iac::java_jdk

class artifactory::install {
  package { $::artifactory::package_name:
    ensure  => $::artifactory::package_version,
    require => Package['jdk']
  }
}
