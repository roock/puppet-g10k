#!/bin/bash

if [ ! -e /home/vagrant/.provision.txt ] ; then

  DISTRIB_CODENAME=$(lsb_release --codename --short)
  DEB="puppet6-release-${DISTRIB_CODENAME}.deb"

  wget "https://apt.puppetlabs.com/${DEB}"
  dpkg -i $DEB
  apt-get update
  apt-get install --yes puppet-agent
  apt-get install --yes lsb-release
  apt-get install --yes vim
  apt-get install --yes byobu
  apt-get install --yes ruby
  apt-get install --yes software-properties-common
  gem install hiera-eyaml
  /opt/puppetlabs/puppet/bin/gem install hiera-eyaml
  apt-get update
  apt-get install --yes puppet-agent
  touch /home/vagrant/.provision.txt
  echo '_byobu_sourced=1 . /usr/bin/byobu-launch' >> /home/vagrant/.profile
fi