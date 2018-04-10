hc_httpd CHANGELOG
===================

This file is used to list changes made in each version of the hc_httpd cookbook.

0.1.36
------
[Przemyslaw Marczynski]
- DE675 - added missing hiredis package on OEL/CentOS 6 as a cookbook file
- US20130 - updated mod_auth_openidc version to 1.8.10.1 (latest from 1.8.x)
- depending on hc_yum instead of yum-epel for more general solution
- added hc_http_proxy to Berksfile for hc_yum >= 1.0.0 support in tests
- fixed Cookstyle issues, simple refactorings and updated header comments in recipes

0.1.18
-----
- [Josh Schneider] - updated so `default.conf` only deploys once as an example. also updated httpd cookbook used to '0.3.3'

0.1.17
-----
- [Stephen Pliska-Matyshak] - add slotmem_shm for Linux 7

0.1.16
-----
- [Stephen Pliska-Matyshak] - refactored user/group creation, simplified module load/config

0.1.12
-----
- [Stephen Pliska-Matyshak] - added .kitchen.cloud.yml for CI/CD, rubocop and foodcritic fixes and README update

0.1.11
-----
- [HuiTing Milewski] - add template guard and use openidc tag for idempotence

0.1.10
-----
- [HuiTing Milewski] - add module conf templates and attribute for user to specify mod

0.1.9
-----
- [HuiTing Milewski] - add proxy mod and two templates to conf.d

0.1.8
-----
- [Stephen Pliska-Matyshak, Josh Schneider] - updated Readme for useful commands

0.1.6
-----
- [Stephen Pliska-Matyshak] - rubocop updates

0.1.5
-----
- [Stephen Pliska-Matyshak] - rubocop exclude updates

0.1.4
-----
- [Stephen Pliska-Matyshak] - rubocop updates

0.1.3
-----
- [Stephen Pliska-Matyshak] - foodcritic updates

0.1.2
-----
- [Stephen Pliska-Matyshak] - readme updated

0.1.1
-----
- [Josh Schnider] - additional modules added

0.1.0
-----
- [Stephen Pliska-Matyshak] - Initial release of hc_iis

0.1.35
-----
- [Artur Pioro] - Updated tomcat-connector to newer version (old is gone)
