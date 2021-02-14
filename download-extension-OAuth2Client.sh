#!/usr/bin/env sh

cd /root

# Installing PHP Composer
# See https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
curl -s https://raw.githubusercontent.com/composer/getcomposer.org/459bcaa/web/installer | php -- --quiet && ln -s /root/composer.phar /usr/bin/composer

cd /var/www/html/extensions

# Following installation steps from https://www.mediawiki.org/wiki/Extension:OAuth2_Client
git clone https://github.com/Schine/MW-OAuth2Client.git 2>&1 && cd MW-OAuth2Client && git submodule update --init 2>&1 && cd vendors/oauth2-client && composer install 2>&1
