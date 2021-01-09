#!/usr/bin/env sh

set -eu

echo "$(date --iso-8601=seconds): starting SQL backup"

# Allow to pass a destination folder as unique argument, defaults to $PWD
project_root=${1:-$PWD}
echo "project_root: $project_root"
backup_folder="${project_root}/backups/$(date -I)"
echo "backup_folder: $backup_folder"
mkdir -p "$backup_folder"
rm -f "${project_root}/backups/latest"
ln -s "$backup_folder" "${project_root}/backups/latest"

# Set $wgReadOnly
docker exec inventaire-mediawiki_web_1 sh -c 'echo "\$wgReadOnly = \"Ongoing database backup, Access will be restored shortly\";" >> /var/www/html/LocalSettings.php'

# Create database backup
# See https://www.mediawiki.org/wiki/Manual:Backing_up_a_wiki/en#Mysqldump_from_the_command_line
docker exec inventaire-mediawiki_database_1 sh -c 'mysqldump --all-databases -u$MYSQL_USER -p$MYSQL_PASSWORD --default-character-set=binary' > "${backup_folder}/wikidb_dump.sql"

# Remove $wgReadOnly
docker exec inventaire-mediawiki_web_1 sh -c 'sed -i "/wgReadOnly/d" /var/www/html/LocalSettings.php'

# Cleanup old backups:
## Delete backups more than 10 days old, unless they are from the first of the month
find "$backup_folder" -mindepth 1 -type d -mtime +10 -not -regex ".*01$" -exec rm -rf {} \;
## Delete backups from the first of each months once passed 6 months
find "$backup_folder" -mindepth 1 -type d -mtime +180 -exec rm -rf {} \;
