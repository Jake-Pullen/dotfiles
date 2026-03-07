#!/usr/bin/env bash
#

# Copy cron tasks to /usr/local/bin
cp /mnt/nas/Jake/cron_tasks/*.sh /usr/local/bin/

# Restore from your saved file
crontab < /mnt/nas/Jake/cron_tasks/cron_backup
