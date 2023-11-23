#! /bin/bash
LOGFILE="/tmp/postrun.log"

if [ $# -eq 0 ]; then
  echo "Nothing to do" | tee -a ${LOGFILE}
  exit 0
fi

for argument in "$@"; do
  /opt/puppetlabs/bin/puppet generate types --environment "${argument}" | tee -a ${LOGFILE}
done