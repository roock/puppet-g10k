# g10k

[![Puppet Forge](http://img.shields.io/puppetforge/v/landcareresearch/g10k.svg)](https://forge.puppetlabs.com/landcareresearch/g10k)
[![Bitbucket Build Status](http://build.landcareresearch.co.nz/app/rest/builds/buildType%3A%28id%3ALinuxAdmin_PuppetG10k_PuppetG10k%29/statusIcon)](http://build.landcareresearch.co.nz/viewType.html?buildTypeId=LinuxAdmin_PuppetG10k_PuppetG10k&guest=1)


## Description

A module to manage g10k for linux based systems.

## Usage

### Class: g10k

####`source_name`
The primary source's name.

####`source_remote`
The primary source's remote url.

####`source_basedir`
The base directory to use for installing components.

####`version`
The version of g10k to install.  
Default: '0.4.7'

####`user`
The user to execute the g10k command.  
Default: 'root'

####`cache_dir`
The path to the cache directory.  
Default: '/var/cache/g10k'

## Reference

## Limitations

Debian Based Systems.