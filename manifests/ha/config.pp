# == Class artifactory::config
#
# This class is called from artifactory for service config.
#
class artifactory::ha::config {
  # Default file sould have artifactory owner and group
  File {
    owner => 'artifactory',
    group => 'artifactory',
  }

  file { "${::artifactory::artifactory_home}/etc/ha-node.properties":
    ensure  => file,
    content => epp(
      'artifactory/ha/ha-node.properties.epp',
      {
        cluster_home    => $::artifactory::ha::cluster_home,
        membership_port => $::artifactory::ha::membership_port,
        is_primary      => $::artifactory::ha::is_primary,
      }
    ),
    mode    => '0644',
  }

  file { "${::artifactory::artifactory_home}/etc/storage.properties":
    ensure => absent,
  }

  # Configure cluster home
  file { $::artifactory::ha::cluster_home:
    ensure => directory,
  }

  file { "${::artifactory::ha::cluster_home}/ha-etc":
    ensure => directory,
  }

  # Create the plugins directory
  file { "${::artifactory::ha::cluster_home}/ha-etc/plugins":
    ensure  => directory,
  }

  # Setup cluster.properties
  file { "${::artifactory::ha::cluster_home}/ha-etc/cluster.properties":
    ensure  => file,
    content => "security.token=${::artifactory::ha::security_token}",
  }

  file { "${::artifactory::ha::cluster_home}/ha-etc/storage.properties":
    ensure  => file,
    content => epp(
      'artifactory/storage.properties.epp',
      {
        db_url                         => $::artifactory::ha::db_url,
        db_username                    => $::artifactory::ha::db_username,
        db_password                    => $::artifactory::ha::db_password,
        db_type                        => $::artifactory::ha::db_type,
        binary_provider_type           => $::artifactory::ha::binary_provider_type,
        pool_max_active                => $::artifactory::ha::pool_max_active,
        pool_max_idle                  => $::artifactory::ha::pool_max_idle,
        binary_provider_cache_maxSize  => $::artifactory::ha::binary_provider_cache_maxSize,
        binary_provider_filesystem_dir => $::artifactory::ha::binary_provider_filesystem_dir,
        binary_provider_cache_dir      => $::artifactory::ha::binary_provider_cache_dir,
      }
    ),
    mode    => '0664',
  }

  file { "${::artifactory::ha::cluster_home}/ha-data":
    ensure => directory,
  }

  file { "${::artifactory::ha::cluster_home}/ha-backup":
    ensure => directory,
  }

  $file_name =  regsubst($::artifactory::ha::jdbc_driver_url, '.+\/([^\/]+)$', '\1')

  ::wget::fetch { $::artifactory::ha::jdbc_driver_url:
    destination => "${::artifactory::artifactory_home}/tomcat/lib/",
  } ->
  file { "${::artifactory::artifactory_home}/tomcat/lib/${file_name}":
    mode => '0755',
  }
}
