# == define tmpreaper::daily
#
# Set a daily cronjob using tmpreaper for the specified directories
#
# === Options
#
# [*name*]
#   absolute path of the directory to clean
#
# [*delay*]
#   Delay  execution at the start for a random time, up to x seconds; if no
#   value is specified, the default maximum time to delay is 256 seconds.
#   This is an option useful in cron scripts to make the execution of tmpreaper
#   less predictable, thus making things a little  harder  for  those
#   who would attempt to use tmpreaper to thwart security.
#   Default: 256.
#
# [*time*]
#   Time to consider files deletable. Can be specified in days (d), hours (h)
#   months (m), seconds (s). Default: 7d.
#
# [*check_method*]
#   by default this define set tmpreaper to check the ctime (inode change time,
#   which is updated e.g. when the file is created or permissions are changed).
#   see man page for more info on this choose. You can specifiy 'mtime' also.
#
# === Example
#
#   tmpreaper::daily { '/var/cache': }
define tmpreaper::daily (
    $ensure         = 'present',
    $delay          = 256,
    $time           = '7d',
    $check_method   = 'ctime',
    $symlinks       = true,
    $user           = 'root',
)
{
    include tmpreaper

    validate_absolute_path($name)

    $safe_name = regsubst($name, '(/|\.)', '-', 'G')


    if ($symlinks == true){
        $symlinks_cmd = '--symlinks'
    } else {
        $symlinks_cmd = ''
    }

    $command = "/usr/sbin/tmpreaper --delay=${delay} --mtime-dir ${symlinks_cmd} --${check_method} ${time} ${name}"

    cron::entry { "tmpreaper-$safe_name":
        ensure    => $ensure,
        frequency => 'daily',
        command   => $command,
        user      => $user,
    }
}
