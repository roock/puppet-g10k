#!/bin/bash
 
if [ -f puppet/logs/puppet.log ] ; then
    rm puppet/logs/puppet.log
fi

if [ ! -d puppet/modules ] ; then
  mkdir -p puppet/modules
fi

CACHEDIR="puppet/g10k_cache"
PUPPETFILE="puppet/Puppetfile"
scripts/g10k -force -cachedir=$CACHEDIR -puppetfile -puppetfilelocation $PUPPETFILE -moduledir puppet/modules

vagrant up --provision
vagrant provision
vagrant provision

if [ $? -eq 0 ] ; then
    echo "*** Manifest deployed without errors ***"
    exit 0
else
    echo "*** Manifest has ERRORs.  See puppet/log/puppet.log for details ***" >&2
    exit 1
fi
