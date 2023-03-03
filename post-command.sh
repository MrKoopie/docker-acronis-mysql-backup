#!/usr/bin/env bash

DIR="$(dirname "${BASH_SOURCE[0]}")"
LOGFILE=$DIR/backup.log

echo "$(date -Ins) ---------------------------------------------------------------------" >> "$LOGFILE"

echo "$(date -Ins) - REMOVING DATABASE BACKUPS." >> "$LOGFILE"
backup_path=$DIR/backups

rm -rf $backup_path/*.gz

echo "$(date -Ins) - DONE." >> "$LOGFILE"
