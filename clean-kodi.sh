#!/bin/bash

LOG_FILE="/tmp/clean-kodi.log"
ARCHIVE_PATH="${HOME}/backup"
DAYS_TO_ARCHIVE="7"

function get_time() {
	local result=$1
	local time=`date +[\%Y-\%m-\%d_\%H:\%M:\%S]`
	eval $result="'$time'"
}

get_time TIME
echo "-----------------------------------------------------------" >> $LOG_FILE
echo "$TIME Starting Kodi Cleanup " >> $LOG_FILE

# Back up the current kodi user data
mkdir -p $ARCHIVE_PATH
get_time TIME
echo "$TIME Starting UserData backup" >> $LOG_FILE
/bin/tar czf "$ARCHIVE_PATH"/kodi_userdata-`date +\%Y\%m\%d_\%H\%M\%S`.tar.gz ~/.kodi/userdata/ >> $LOG_FILE 2>&1

# Remove any kodi user data archive that is older then 7 days
get_time TIME
echo "$TIME Removing old UserData archives" >> $LOG_FILE
/usr/bin/find $ARCHIVE_PATH/kodi_userdata-* -mtime +"$DAYS_TO_ARCHIVE" -delete  >> $LOG_FILE 2>&1

