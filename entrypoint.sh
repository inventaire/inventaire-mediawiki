#!/bin/bash

# Test if required environment variables have been set
REQUIRED_VARIABLES=(SECRET_KEY MYSQL_SERVER MYSQL_USER MYSQL_PASSWORD MYSQL_DATABASE)
for i in ${REQUIRED_VARIABLES[@]}; do
    eval THISSHOULDBESET=\$$i
    if [ -z "$THISSHOULDBESET" ]; then
    echo "$i is required but isn't set. You should pass it to docker via the .mw_env file";
    exit 1;
    fi
done

set -eu

# Wait for the db to come up
/wait-for-it.sh $MYSQL_SERVER -t 300
# Sometimes it appears to come up and then go back down meaning MW install fails
# So wait for a second and double check!
sleep 1
/wait-for-it.sh $MYSQL_SERVER -t 300

# Run extra scripts everytime
if [ -f /extra-entrypoint-run-first.sh ]; then
    source /extra-entrypoint-run-first.sh
fi

# Do the mediawiki install (only if LocalSettings doesn't already exist)
if [ ! -e "/var/www/html/LocalSettings.php" ]; then

    # Test additionnaly required environment variables for the first run
    REQUIRED_INSTALLATION_VARIABLES=(ADMIN_NAME ADMIN_PASS ADMIN_EMAIL)
    for i in ${REQUIRED_INSTALLATION_VARIABLES[@]}; do
        eval THISSHOULDBESET=\$$i
        if [ -z "$THISSHOULDBESET" ]; then
        echo "$i is required but isn't set. You should pass it to docker via the .mw_env file";
        exit 1;
        fi
    done

    # Setup the database (needs to be done before copying our custom LocalSettings.php)
    php /var/www/html/maintenance/install.php --dbuser $MYSQL_USER --dbpass $MYSQL_PASSWORD --dbname $MYSQL_DATABASE --dbserver $MYSQL_SERVER --lang $SITE_LANG --pass $ADMIN_PASS $SITE_NAME $ADMIN_NAME
    php /var/www/html/maintenance/resetUserEmail.php --no-reset-password $ADMIN_NAME $ADMIN_EMAIL

    # Copy our LocalSettings into place after install
    cp /LocalSettings.php /var/www/html/LocalSettings.php

    # Run update.php now that LocalSettings.php is in place, to install extensions
    php /var/www/html/maintenance/update.php --quick

    # Run extrascripts on first run
    if [ -f /extra-install.sh ]; then
        source /extra-install.sh
    fi
fi

# Run the actual entry point
docker-php-entrypoint apache2-foreground
