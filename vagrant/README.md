# Testing

## About

This directory contains vagrant code for testing this module.  This utilizes R10K + Puppet in order to pull all of the necessary dependencies.  It uses the main test class (tests/init.pp) for testing.

## Requirements

Your system must have the following already installed.

* virtualbox
* vagrant
* puppet
* r10k

## Operating Systems

The vagrant configuration file uses a variable to load the OS used by the vagrant provider (such as virtual box).   This allows for a script to loop across all supported OS's.

### Selecting an OS

If you want to test a specific OS Version, do the following.

* Edit the config/testos.rb
* Set the require statement to the OS to be tested.

See below:

```ruby
require './config/ubuntu12.04'
```

## Test Single VM

To test a single configuration do the following:

```bash
vagrant destroy
./scripts/run.bash
```

This will ensure that any previous test runs are destroyed before starting a new one.  See the output.  The last line should indicate if the test passed or failed.

## Test All VMs

To test all supported vms, do the following:

```bash
./test.bash
```
