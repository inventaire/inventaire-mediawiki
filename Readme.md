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

### Manual Backups

Dump pages in an xml file :

```
docker exec inventaire-mediawiki_web_1 sh -c 'php /var/www/html/maintenance/dumpBackup.php --current --dbuser $WGDBUSER --dbpass $WGDBPASSWORD' > /home/admin/inventaire-mediawiki/manual-backups/wiki_backup.current.xml
```

Export db to .sql :

```
docker exec inventaire-mediawiki_database_1 sh -c 'mysqldump --all-databases -u$MYSQL_USER -p$MYSQL_PASSWORD --default-character-set=binary' > manual-backups/wikidb_dump.sql
```

