#!/bin/bash

# YouTube Upload Handler
# This script is called by Folder Action and handles the complete upload workflow

SCRIPT_DIR="$HOME/Documents/personalAutomation/youtubeUpload"
LOCK_FILE="$SCRIPT_DIR/.upload_lock"
LOG_FILE="$SCRIPT_DIR/upload.log"
WATCH_DIR="$SCRIPT_DIR/airdropVideos"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# Check if lock file exists and is recent (less than 2 hours old)
if [ -f "$LOCK_FILE" ]; then
    # Check lock file age
    if [ $(( $(date +%s) - $(stat -f %m "$LOCK_FILE") )) -lt 7200 ]; then
        log "Upload already in progress, exiting"
        exit 0
    else
        log "Stale lock file detected, removing"
        rm -f "$LOCK_FILE"
    fi
fi

# Create lock file
touch "$LOCK_FILE"
log "Lock file created, starting upload"

# Ensure lock is removed on exit
trap "rm -f $LOCK_FILE; log 'Lock file removed'" EXIT

# Wait longer for file to stabilize after move
sleep 5

# Open Terminal and run the interactive upload script
log "Opening Terminal for interactive upload"
osascript <<EOF
tell application "Terminal"
    activate
    set newWindow to do script "cd ~/Documents/personalAutomation/youtubeUpload && source venv/bin/activate && python youtube_uploader.py && exit"
    repeat
        delay 1
        if not busy of newWindow then
            close newWindow
            exit repeat
        end if
    end repeat
end tell
EOF

log "Upload process completed"
