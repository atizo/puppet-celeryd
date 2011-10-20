#
# celeryd module
#
# Copyright 2011, Atizo AG
# Simon Josi simon.josi+puppet(at)atizo.com
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

class celeryd(
  $virtualenv,
  $celeryd,
  $celeryd_log_file,
  $pythonpath = '',
  $user => nobody,
  $group = nobody
) {
  file{'/etc/sysconfig/celeryd':
    content => template('modules/celeryd/celeryd.sysconfig'),
    notify => Service['celeryd'],
    owner => root, group => root, mode => 0444;
  }
  file{'/etc/init.d/celeryd':
    source => "puppet://$server/modules/celeryd/celeryd.init",
    notify => Service['celeryd'],
    owner => root, group => root, mode => 0555;
  }
  file{'/var/run/celeryd':
    ensure => directory,
    owner => $user, group => $group, mode => 0750,
  }
  service{'celeryd':
    ensure => running,
    enable => true,
    hasstatus => true,
    require => [
      File['/etc/sysconfig/celeryd'],
      File['/etc/init.d/celeryd'],
      File['/var/run/celeryd'],
    ]
  }
}
