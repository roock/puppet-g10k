#!/bin/bash
if service --status-all | grep -Fq 'apache2'; then    
  service apache2 stop
  apt install -f
  apt update
  service apache2 start
fi