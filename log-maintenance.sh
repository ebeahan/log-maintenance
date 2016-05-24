#!/bin/bash

# This script can perform the following functions:
#
# GZIP logs that have not been modified in the last five minutes.
# Intention is for logs that roll over at the top of the hour
# to be gzip'd on the next scheduled iteration of the script
# (e.g. cron job)
#
# Cleanup old old *.log.gz files left in the directory after
# they have been read/parsed by external sources.

LOG_PATH=/path/to/logs

case "$1" in

    gzip)
        for i in $( find $LOG_PATH/*.log -mmin +5 -type f -print ); do
            temp=$( echo -n ${i} | cut -d '.' -f 1 )
            gzip -c $i > ${temp}_$(date +%m%d%y).log.gz
            rm -f $i
        done
    ;;

    cleanup)
        for i in $( find $LOG_PATH/*.log.gz -mtime +1 -type f -print); do
            rm -f $i
        done
    ;;

    *)
        echo "Usage: Log maintenance related actions"
        echo "    gzip: gzip the current log files."
        echo "    cleanup: cleanup already parsed log files."
    ;;
esac
exit 0


