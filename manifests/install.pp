# == Class artifactory::install
#
# This class is called from artifactory for install.
#

Yum::Repo <| title == 'cegeka-custom-noarch' |>

class artifactory::install {
  if ($::artifactory::manage_java) {
    package { 'java-1.8.0-openjdk': }
  }
  package { $::artifactory::package_name:
    ensure  => $::artifactory::package_version
  }
}
