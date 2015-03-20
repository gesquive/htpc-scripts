#!/bin/bash

LOG_FILE="/opt/htpc/clean-xbmc.log"
ARCHIVE_PATH="~/backup"
DAYS_TO_ARCHIVE="7"

function get_time() {
	local result=$1
	local time=`date +[\%Y-\%m-\%d_\%H:\%M:\%S]`
	eval $result="'$time'"
}

get_time TIME
echo "-----------------------------------------------------------" >> $LOG_FILE
echo "$TIME Starting XBMC Cleanup " >> $LOG_FILE

# Check if the network is available
TMP_FILE="/tmp/index.router"
/usr/bin/wget -q --tries=10 --timeout=10 http://192.168.1.1 -O $TMP_FILE &> /dev/null
get_time TIME
if [ ! -s $TMP_FILE ];then
	echo "$TIME Could not contact the router, exiting script" >> $LOG_FILE
	exit
else
	echo "$TIME Network found" >> $LOG_FILE
	rm $TMP_FILE
fi

# Back up the current xbmc user data
get_time TIME
echo "$TIME Starting UserData backup" >> $LOG_FILE
/bin/tar czf "$ARCHIVE_PATH"/xbmc-`date +\%Y\%m\%d_\%H\%M\%S`.tar.gz ~/.xbmc/userdata >> $LOG_FILE 2>&1

# Remove any xbmc user data archive that is older then 7 days
get_time TIME
echo "$TIME Removing Old UserData archives" >> $LOG_FILE
/usr/bin/find ~/backup/ -depth -mindepth 1 -mtime +"$DAYS_TO_ARCHIVE" -delete >> $LOG_FILE

# Tell xbmc to update the video library
get_time TIME
echo "$TIME Updating XBMC Video Library" >> $LOG_FILE
/usr/bin/xbmc-send -a "UpdateLibrary(video)" >> $LOG_FILE 2>&1

# Finally tell xbmc to clean the library of any missing entries
#get_time TIME
#echo "$TIME Cleaning XBMC Video Library" >> $LOG_FILE
#/usr/bin/xbmc-send -a "CleanLibrary(video)" >> $LOG_FILE 2>&1

