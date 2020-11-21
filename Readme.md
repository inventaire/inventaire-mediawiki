# Inventaire wiki

Based on manual https://www.mediawiki.org/wiki/Docker/Hub but with repository url as: `git clone https://gerrit.wikimedia.org/r/mediawiki/core.git --branch REL1_35 html`

## Installation
### Quick start
 - `cp dot_mw_env .mw_env && cp dot_db_env .db_env`
 - Start compose `docker-compose up`

In case of database not found error, start the maintenance script update.php (for example with `docker exec -it container_name php /var/www/html/maintenance/update.php`)

## Administration

### Manually change page language

see `Special:PageLanguage`

more details at: https://www.mediawiki.org/wiki/Manual:Language#Page_content_language

### Regarding translations administration

One can see current status of translated pages through the special page `Special:PageTranslation`

## System Administration

### Backups

#### Backup Docker volumes
See https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes

Add a cron job in `/etc/cron.daily/` to run script `archive_backup_now.sh`

#### Backup MySQL
See https://www.mediawiki.org/wiki/Manual:Backing_up_a_wiki/en#Mysqldump_from_the_command_line

```sh
# Set $wgReadOnly
docker exec inventaire-mediawiki_web_1 sh -c 'echo "\$wgReadOnly = \"Ongoing database backup, Access will be restored shortly\";" >> /var/www/html/LocalSettings.php'
# Create database backup
docker exec inventaire-mediawiki_database_1 sh -c 'mysqldump --all-databases -u$MYSQL_USER -p$MYSQL_PASSWORD --default-character-set=binary' > wikidb_dump.sql
# Remove $wgReadOnly
docker exec inventaire-mediawiki_web_1 sh -c 'sed -i "/wgReadOnly/d" /var/www/html/LocalSettings.php'
```

To restore
```sh
docker cp ./wikidb_dump.sql inventaire-mediawiki_database_1:/wikidb_dump.sql
docker exec inventaire-mediawiki_database_1 sh -c 'mysql -u$MYSQL_USER -p$MYSQL_PASSWORD < /wikidb_dump.sql'
docker exec inventaire-mediawiki_web_1 sh -c 'php /var/www/html/maintenance/update.php'
```

#### Backup Images

```sh
docker cp inventaire-mediawiki_web_1:/var/www/html/images .
tar cvf images.tar ./images
```
To restore
```sh
docker cp ./images.tar inventaire-mediawiki_web_1:/tmp/images.tar
docker exec inventaire-mediawiki_web_1 sh -c 'tar xvf /tmp/images.tar --directory /var/www/html/images'
docker restart inventaire-mediawiki_web_1
```

#### Backup wiki
```sh
docker exec inventaire-mediawiki_web_1 sh -c 'php /var/www/html/maintenance/dumpBackup.php --full --dbuser $MYSQL_USER --dbpass $MYSQL_PASSWORD' > wiki_backup.xml
```
