Nagios Monitoring
=================

Basic NRPE monitoring system

Usage:

    class {'monitoring':
        monitor_ip => '127.0.0.1',
    }

Requires
--------

 * https://github.com/stahnma/puppet-module-epel
 * https://github.com/puppetlabs/puppetlabs-firewall
 * https://github.com/hercules-team/augeasproviders
