#!/bin/bash

# Configuration
SOURCE_DIR="/mnt/storage/Downloads"
DEST_DIR="/home/steve/new_books"
TIMESTAMP_FILE="/home/steve/.last_book_upload_time"

# Resolve full path of this script so we can exclude it
SCRIPT_PATH="$(readlink -f "$0")"

# Ensure destination exists
mkdir -p "$DEST_DIR"

# If no timestamp file exists, create one with a default time
if [ ! -f "$TIMESTAMP_FILE" ]; then
    echo "First run. Creating timestamp file."
    date -d "1 day ago" +"%Y-%m-%d %H:%M:%S" > "$TIMESTAMP_FILE"
fi

# Read the last run time
LAST_RUN=$(cat "$TIMESTAMP_FILE")

echo "Syncing items modified since: $LAST_RUN"

# Find modified items (top-level only), excluding this script
find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -newermt "$LAST_RUN" -print0 |
while IFS= read -r -d '' ITEM; do
    ITEM_PATH="$(readlink -f "$ITEM")"
    if [ "$ITEM_PATH" != "$SCRIPT_PATH" ]; then
        rsync -rP "$ITEM" "$DEST_DIR/"
    fi
done

# Update timestamp after sync
date +"%Y-%m-%d %H:%M:%S" > "$TIMESTAMP_FILE"
