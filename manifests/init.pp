## \file    manifests/init.pp
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#  \brief
#
#  Copyright 2013 Scott Wales
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

class monitoring (
  $monitor_ip = undef,
) {
  # Nagios packages are provided by epel
  include epel
  Package {
    require => Class['epel']
  }

  package {'nrpe':} ->
  service {'nagios-nrpe-server':
    ensure => running,
  }

  # NRPE server runs on port 5666
  if $monitor_ip {
    monitoring::remote_ip{$monitor_ip:}
  }

  $pluginpath = '/usr/lib64/nagios/plugins'

  # Setup the lens
  file {'/usr/share/augeas/lenses/nrpe.aug':
    ensure => present,
    source => 'puppet:///modules/monitoring/nrpe.aug',
  } ->
  Nrpe_command {
    ensure  => present,
    require => Package['nrpe'],
    notify  => Service['nagios-nrpe-server'],
  }

  # Checks to run:
  # ==============
  nrpe_command {'check_disk':
    command => "${pluginpath}/check_disk -w 20% -c 10%",
  }

}

