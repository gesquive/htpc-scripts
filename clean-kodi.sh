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

# Check if the network is available
#TMP_FILE="/tmp/index.router"
#/usr/bin/wget -q --tries=10 --timeout=10 http://192.168.1.1 -O $TMP_FILE &> /dev/null
#get_time TIME
#if [ ! -s $TMP_FILE ];then
#	echo "$TIME Could not contact the router, exiting script" >> $LOG_FILE
#	exit
#else
#	echo "$TIME Network found" >> $LOG_FILE
#	rm $TMP_FILE
#fi


# Back up the current kodi user data
mkdir -p $ARCHIVE_PATH
get_time TIME
echo "$TIME Starting UserData backup" >> $LOG_FILE
/bin/tar czf "$ARCHIVE_PATH"/kodi_userdata-`date +\%Y\%m\%d_\%H\%M\%S`.tar.gz ~/.kodi/userdata/ >> $LOG_FILE 2>&1

# Remove any kodi user data archive that is older then 7 days
get_time TIME
echo "$TIME Removing old UserData archives" >> $LOG_FILE
/usr/bin/find $ARCHIVE_PATH/kodi_userdata-* -mtime +"$DAYS_TO_ARCHIVE" -delete  >> $LOG_FILE 2>&1

# Tell kodi to update the video library
#get_time TIME
#echo "$TIME Updating Kodi Video Library" >> $LOG_FILE
#/usr/bin/kodi-send -a "UpdateLibrary(video)" >> $LOG_FILE 2>&1

# Finally tell kodi to clean the library of any missing entries
#get_time TIME
#echo "$TIME Cleaning Kodi Video Library" >> $LOG_FILE
#/usr/bin/kodi-send -a "CleanLibrary(video)" >> $LOG_FILE 2>&1

