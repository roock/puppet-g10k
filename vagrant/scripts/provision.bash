#!/bin/bash
 
mkdir -p puppet/modules
PUPPETFILE=puppet/Puppetfile PUPPETFILE_DIR=puppet/modules r10k --verbose 3 puppetfile install

vagrant provision 

if [ $? -eq 0 ] ; then
    echo "*** Manifest deployed without errors ***"
    exit 0
else
    echo "*** Manifest has ERRORs.  See puppet/log/puppet.log for details ***" >&2
    exit 1
fi
