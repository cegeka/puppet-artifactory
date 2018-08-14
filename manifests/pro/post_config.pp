# == Class artifactory::config
#
# This class is called from artifactory for service config.
#
class artifactory::pro::post_config {
  # Add the license file
  create_resources('::artifactory::pro::plugin', $::artifactory::pro::plugin_urls)
}
