#!/bin/bash

if [ ! -e /home/vagrant/.provision.txt ] ; then
    sudo rpm -Uvh https://yum.puppet.com/puppet5-release-el-6.noarch.rpm
    sudo yum install -y puppet-agent
    touch /home/vagrant/.provision.txt
fi
