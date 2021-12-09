#!/bin/bash
#
# Install Backup Script

set -e

apt-get update && apt-get -y install unzip

# Cleanup previous versions
if [ -f /usr/local/bin/rclone ]; then
  rm /usr/local/bin/rclone
fi

cd /tmp \
  && curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip \
  && unzip rclone-current-linux-amd64.zip \
  && cd rclone-*-linux-amd64 \
  ; \
  mv rclone /usr/local/bin/ && chmod 655 /usr/local/bin/rclone \
  && cd ~ \
  ; \
  rm -rf /tmp/rclone* \
  ; \
  curl https://raw.githubusercontent.com/ComputeStacks/controller-backups/HEAD/backup.sh > /usr/local/bin/controller-backup \
  && chmod +x /usr/local/bin/controller-backup \
  ; \
  curl https://raw.githubusercontent.com/ComputeStacks/controller-backups/HEAD/rclone-cron.sh > /usr/local/bin/rclone-cron \
  && chmod +x /usr/local/bin/rclone-cron \
  ; \
  mkdir -p /var/log/rclone
