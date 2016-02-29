# == class: tmpreaper
#
# Install tmpreaper package and setup the concat used by tmpreaper::dir
#
# By deafault the package schedule a daily job with some default dirs
# maintained clean (/tmp /var/tmp /var/cache).
#
# It's possible to add more directories to this default job using
# tmpreaper::dir
#
# To create a job with custom parameters (user, delay, time, etc..) use
# tmpreaper::daily
#
# === Parameters
#
# [*ensure*]
#   present (default) or absent
#
# [*tmpreaper_time*]
#   time after witch a file is deleted by tmpreaper. default: 60 days
#
# === Todo:
# - TEST ensure=absent
#
class tmpreaper(
  $ensure ='present',
  $tmpreaper_time='60d',
){

  validate_re($ensure, '(present|absent)', "ensure must be 'present' or 'absent', checked value is '${ensure}'")
  validate_re($tmpreaper_time, '\d+(d|m|h|s)?')

  package{ 'tmpreaper':
    ensure => $ensure,
  }

  concat{ '/etc/tmpreaper.conf':
    owner => root,
    group => admin,
    mode  => 664,
    warn  => true,
  }

  concat::fragment{ 'tmpreaper.conf_general':
    target  => '/etc/tmpreaper.conf',
    order   => '05',
    content => template('tmpreaper/tmpreaper.conf.erb')
  }
}
