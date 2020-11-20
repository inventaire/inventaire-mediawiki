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

See https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes

Add a cron job in `/etc/cron.daily/` to run script `archive_backup_now.sh`
