# == Class artifactory::config
#
# This class is called from artifactory for service config.
#
class artifactory::ha::post_config {
  # Add the license file
  create_resources('::artifactory::ha::plugin', $::artifactory::ha::plugin_urls)
}
