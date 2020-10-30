#!/bin/bash
set -eu

cd "/home/admin/inventaire-mediawiki"

epoch_time="$(date +%s)"
backup_db="database$epoch_time"

docker run --rm -v inventaire-mediawiki_database:/backups \
  -v $(pwd)/backups:/backup \
  alpine \
  tar cvf "/backup/$backup_db.tar" /backups

backup_images="images$epoch_time"

docker run --rm -v inventaire-mediawiki_images:/backups \
  -v $(pwd)/backups:/backup \
  alpine \
  tar cvf "/backup/$backup_images.tar" /backups

#if there are more than 20 backups (10 db + 10 images), delete backups more than 10 days old
files_count="$(ls -1 $(pwd)/backups | wc -l)"
if [ "$files_count" -gt "20" ];
then
  find $(pwd)/backups -type f -mtime +10 -exec rm -f {} \;
fi

#restore a backup with
#docker run --rm \
#  -v inventaire-mediawiki_database:/backups \
#  -v $(pwd)/backups:/backup \
#  alpine \
#  tar xvf "/backup/$backup_db.tar" -C /backups --strip 1

#where --strip 1 remove leading path elements
#See https://stackoverflow.com/questions/38298645
