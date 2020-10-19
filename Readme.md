# Inventaire wiki

## Installation

Based on manual https://www.mediawiki.org/wiki/Docker/Hub but with repository url as: `git clone https://gerrit.wikimedia.org/r/mediawiki/core.git --branch REL1_35 html`

### Quick start
 - Comment line `- ./LocalSettings.php:/var/www/html/LocalSettings.php` in `docker-compose.yml`
 - Start compose `docker-compose up`
 - Complete install script
 - Uncomment LocalSettings volume
 - Restart containers

In case of database not found error, start the maintenance script update.php (for example with `docker exec -it container_name php /var/www/html/maintenance/update.php`)

## Administration

### Manually change page language

see `Special:PageLanguage`

or

through the API: `api.php?action=setpagelanguage&title=Association&lang=fr&token=123ABC`

more details at: https://www.mediawiki.org/wiki/Manual:Language#Page_content_language

### Regarding translations administration

One can see current status of translated pages through the special page `Special:PageTranslation`

