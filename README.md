httpd cookbook
=================
Installs httpd on server and creates a default website (/etc/httpd-default).
Version 2.2 (mpm_worker) is installed on Linux 6.x
Version 2.4 (mpm_event) is installed on Linxu 7.x

## Supported Platforms

CentOS,
Oracle Linux

## Versions by Environments

PROD: 0.1.11 (Last Updated Oct. 23, 2015), 0.1.10
DEV: 0.1.11

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>['httpd']['user']</td>
    <td>string</td>
    <td>Run user</td>
    <td>'jeeadm'</td>
  </tr>
  <tr>
    <td>['httpd']['group']</td>
    <td>string</td>
    <td>Run group</td>
    <td>'jeeadm'</td>
  </tr>
  <tr>
    <td>['httpd']['app_dir']</td>
    <td>string</td>
    <td>Operations application link directory</td>
    <td>'/apps/jeeapp'</td>
  </tr>
  <tr>
    <td>['httpd']['log_dir']</td>
    <td>string</td>
    <td>Operations log link directory</td>
    <td>'/logs/jeeapp'</td>
  </tr>
</table>

## Usage
- This cookbook creates a service called httpd-default, httpd is not to be used
- Most modules included with httpd are loaded by default
- mod_jk and OpenIDC are not installed by default, for installation instructions see below
- .conf files for the various modules are to be placed in /etc/httpd-default/conf.d
- stubs for a number of module .conf files are included for modification and will not be overwritten

### httpd::default

Include `httpd` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[httpd::default]"
  ]
}
```


Adds OpenIDC to httpd configuration (will block default website)

```json
{
  "run_list": [
    "recipe[httpd::default]"
    "recipe[httpd::mod_auth_openidc]"
  ]
}
```

### httpd::mod_jk

Adds mod_jk to httpd configuration

```json
{
  "run_list": [
    "recipe[httpd::default]"
    "recipe[httpd::mod_jk]"
  ]
}
```
