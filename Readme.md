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
#### Backup MySQL
Export db to .sql

```sh
./scripts/backup_sql_db.sh
```

To run it daily, to you a cron job in `/etc/cron.daily/` that could look like this:
```sh
#!/usr/bin/env sh
/home/admin/inventaire-mediawiki/scripts/backup_sql_db.sh /home/admin/inventaire-mediawiki > /home/admin/inventaire-mediawiki/backups/logs 2>&1
```

To restore
```sh
# Requires to have the 'database' service up
docker cp ./wikidb_dump.sql inventaire-mediawiki_database_1:/wikidb_dump.sql
docker exec inventaire-mediawiki_database_1 sh -c 'mysql -u$MYSQL_USER -p$MYSQL_PASSWORD < /wikidb_dump.sql'
# Requires to have the 'web' service up
docker exec inventaire-mediawiki_web_1 sh -c 'php /var/www/html/maintenance/update.php'
```

#### Backup images
As the `images` volume is mounted from `./images`, the easiest way to backup images is to `rsync` that folder from where you want to keep the backup:
```
mkdir -p ./backups/images
rsync -ahz server_name:~/inventaire-mediawiki/images/ ./backups/images
```

Alternatively, you could also create an archive file:

```sh
tar -zcf images.tar.gz ./images/
```

To restore
```sh
# Will recreate the image folder that is then mounted as volume by in docker-compose.yml
tar xzf images.tar.gz
```

#### Backup wiki
Dump pages in an xml file:
```sh
docker exec inventaire-mediawiki_web_1 sh -c 'php /var/www/html/maintenance/dumpBackup.php --full --dbuser $MYSQL_USER --dbpass $MYSQL_PASSWORD' > wiki_backup.xml
```

If you are already running MySQL backup, this would be redundant, but it can sometimes be useful to access this kind of backup as it's easier to manipulate as text (ex: to run `grep` on it)
