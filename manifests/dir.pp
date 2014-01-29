# == define: tmpreaper
#
# Add directory $name to the paths managed by tmpreaper
#
# === Usage:
#
#   tmpreaper::dir { '/var/local/tmp': }
#
define tmpreaper::dir {

  include tmpreaper

  validate_absolute_path($name)

  $safe_fragment_name = regsubst($name, '/', '_', 'G')

  concat::fragment{ "tmpreaper_${safe_fragment_name}":
    target  => '/etc/tmpreaper.conf',
    order   => 20,
    content => "\nTMPREAPER_DIRS=\"\$TMPREAPER_DIRS ${name}/.\"\n",
  }

}
