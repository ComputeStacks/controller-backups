#!/bin/bash
#
# ComputeStacks backup to rclone remote
#
set -e

LOCAL_BACKUPS_TO_KEEP=7
RCLONE_PROFILE=
RCLONE_REMOTE_PATH=

# To override the above, place them in this file
. /etc/default/computestacks

# Should exist, so if it doesn't, something is seriously wrong!
if [ ! -d $DB_BACKUPS_PATH ]; then
  echo "Error, backups path does not exist"
  exit 1
fi

if [ ! -z "$LOCAL_BACKUPS_TO_KEEP" -a "$LOCAL_BACKUPS_TO_KEEP" != " " ]; then
  echo "Missing LOCAL_BACKUPS_TO_KEEP"
  exit 1
fi

cstacks database-backup \
  && echo "Keeping latest ${LOCAL_BACKUPS_TO_KEEP} backups" \
  && ls -dt $DB_BACKUPS_PATH/* | tail -n +$LOCAL_BACKUPS_TO_KEEP  | xargs rm -rf

if [ ! -z "$RCLONE_PROFILE" -a "$RCLONE_PROFILE" != " " ] && [ ! -z "$RCLONE_REMOTE_PATH" -a "$RCLONE_REMOTE_PATH" != " " ]; then
  /usr/local/bin/rclone-cron "${DB_BACKUPS_PATH}" $RCLONE_PROFILE:$RCLONE_REMOTE_PATH >> /var/log/rclone/rclone-cron.log 2>&1
else
  echo "rclone not configured, skipping..."
fi
