#!/usr/bin/env bash
#

# Copy cron tasks to /usr/local/bin only if source is newer
for script in /mnt/nas/Jake/cron_tasks/*.sh; do
    if [ -f "$script" ]; then
        basename=$(basename "$script")
        dest="/usr/local/bin/$basename"
        if [ ! -f "$dest" ] || [ "$(stat -c %Y "$script")" -gt "$(stat -c %Y "$dest" 2>/dev/null || echo 0)" ]; then
            sudo cp "$script" "$dest"
            echo "  Updated $basename"
        else
            echo "  Skipped $basename (up to date)"
        fi
    fi
done

# Restore crontab only if backup is newer than current crontab
CRON_BACKUP="/mnt/nas/Jake/cron_tasks/cron_backup"
if [ -f "$CRON_BACKUP" ]; then
    CURRENT_CRON=$(mktemp)
    crontab -l >"$CURRENT_CRON" 2>/dev/null || true
    
    if ! diff -q "$CURRENT_CRON" "$CRON_BACKUP" >/dev/null 2>&1; then
        crontab < "$CRON_BACKUP"
        echo "  Cron jobs updated"
    else
        echo "  Cron jobs up to date"
    fi
    
    rm -f "$CURRENT_CRON"
else
    echo "Error: Cron backup file not found at $CRON_BACKUP" >&2
    exit 1
fi
