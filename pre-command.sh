#!/usr/bin/env bash

#set -euo pipefail
mysqldump_parameters='--force --single-transaction --events --routines'

DIR="$(dirname "${BASH_SOURCE[0]}")"

backup_path=$DIR/backups
LOGFILE=$DIR/backup.log

cd $backup_path

#cat /opt/apps/base/.env >> "$LOGFILE"
echo "$(date -Ins) ---------------------------------------------------------------------" >> "$LOGFILE"

echo "$(date -Ins) - Pre-backup database dump script started." >> "$LOGFILE"

for database in $(docker exec -t mysql mysql -u root --password=$(grep -i password /opt/apps/base/.env | cut -c 21-) -e 'show databases' -s --skip-column-names | grep -v Warning); do
	database=`echo $database| tr -cd '[:alnum:]._-'`
	# We cannot dump information_schema
	if [ $database == "information_schema" ] || [ $database == "performance_schema" ]; then
		continue;
	fi

	echo "$(date -Ins) - Starting with $database" >> "$LOGFILE"
	docker exec -t mysql mysqldump -u root --password=$(grep -i password /opt/apps/base/.env | cut -c 21-) $mysqldump_parameters $database | gzip > $backup_path/$database.sql.gz
	echo "$(date -Ins) - Done with $database" >> "$LOGFILE"
done
echo "$(date -Ins) - Pre-backup database dump script finished." >> "$LOGFILE"
