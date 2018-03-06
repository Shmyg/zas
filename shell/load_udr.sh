#!/usr/bin/bash

# Script for loading rejected UDRs/BIRs into Oracle
# Looks for the data in the standard BSCS directory $WORK/MP/ERROR/PRIH
# based on the parameters specified (BIR|UDR and date to process),
# then loads those files in REJECTED_RECORDS table for anlysis
# Created by Serge Shmygelskyy aka Shmyg // serge@shmygelskyy.name
# $Log: load_udr.sh,v $
# Revision 1.2  2013/11/12 12:36:31  shmyg
# Modified according to comments from operations. Changes:
# 1. Added filename, record_num and line_num to each line.
# 2. Added parameters to shell script.
# 3. Modified PATH to look for files, now based on .
# 4. Replaced sed script with awk
#
# Revision 1.1  2013/11/11 08:24:39  shmyg
# First working version for UDR loader
#

# Environment
DB_USER=SYSADM
DB_PASS=SYSADM
DB_NAME=sadev

BASE_DIR=/BILLINGPRE/applications/bscspre/billing/sadev/shmyg/zas/udr
DATA_DIR="$WORK"/MP/ERROR/PRIH
LOG_DIR="$BASE_DIR"/log
CONTROL_FILE="$BASE_DIR"/load_udr.ctl

# Verifying record type to be loaded, should be either UDR or BIR
case "$1" in
  "") echo "Usage: ${0##*/} BIR|UDR <yyyymmdd>"; exit 1;;
  "BIR") DIR_MASK=M59; RECORD_MASK=BIR;;
  "UDR") DIR_MASK=M8; RECORD_MASK=UDR;;
  *) echo "Usage: ${0##*/} BIR|UDR <yyyymmdd>"; exit 1;;
esac

# Date mask should be provided (yyyymmdd)
case "$2" in
  "") echo "Usage: ${0##*/} BIR|UDR <yyyymmdd>"; exit 1;;
  *) FILE_MASK=${2};;
esac

# Startup checks
# Checking that DB access vars set
if [ -z "$DB_USER" -o -z "$DB_NAME" -o -z "$DB_PASS" ] ; then
 echo "Cannot access database - DB_USER/DB_NAME/DB_PATH not set"
 exit
fi

# Checking working environment
if [ -z "$LOG_DIR" -o -z "$WORK" ] ; then
 echo "LOG_DIR or WORK_DIR is not set"
 exit
fi

# Checking if control file exists
if [ ! -r "$CONTROL_FILE" ]; then
  echo "Control file $CONTROL_FILE doesn't exist or is not readable!"
  exit 1
fi

# Looking for files and try to load them into the database
for FILE_NAME in `find "$WORK"/"$DIR_MASK"* -type f -a -name ERR"$FILE_MASK"* `; do
 DATA_FILE=`basename ${FILE_NAME#*/}`
  # Adding filename to each row in datafile through fifo
  #sed -n -f "$BASE_DIR"/normalize_udr.sed $FILE_NAME | sed "s/:/,/" | sed "s/$/,"$DATA_FILE","$RECORD_MASK"/" > "$BASE_DIR"/payments.fifo &
  awk -f "$BASE_DIR"/udr.awk $FILE_NAME | sed "s/^/"$DATA_FILE","$RECORD_MASK",/" | sed "s/:/,/" > "$BASE_DIR"/payments.fifo &
  # Invoking SQL*Loader
  echo $DB_PASS | \
          sqlldr control=$CONTROL_FILE \
	  data="$BASE_DIR"/payments.fifo \
 	  log=$LOG_DIR/$DATA_FILE.log \
 	  bad=$LOG_DIR/$DATA_FILE.bad \
  	  discard=$LOG_DIR/$DATA_FILE.disc \
  	  userid=$DB_USER@$DB_NAME

  RET_CODE=$?

  # Checking return code
  # 2 - it's warning - maybe some bad records found
  if [ "$RET_CODE" -eq "0" -o "$RET_CODE" -eq "2" ]; then
   # Checking if there is discards file
   test -f $LOG_DIR/$FILE_NAME.disc && rm -f $LOG_DIR/$FILE_NAME.disc
  else
   echo "SQL*Loader returned with code $RET_CODE. Something might be wrong - you'd better check"
  fi  
done
