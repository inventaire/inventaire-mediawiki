FROM mediawiki:1.35.4

# extension install inspired from https://github.com/wmde/wikibase-docker/blob/master/wikibase/1.35/bundle/Dockerfile

RUN apt-get update && \
    apt-get install --yes --no-install-recommends jq=1.* curl=7.* unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/extensions

COPY download-extension.sh .
COPY download-extension-OAuth2Client.sh .
COPY wait-for-it.sh /wait-for-it.sh
COPY entrypoint.sh /entrypoint.sh

# Add RUN command to each lines for development ease (instead of ending line with `;\`),
# as it does not recreate a container (and download all extensions again) when adding new extension

RUN bash download-extension.sh Babel
RUN bash download-extension.sh Cite
RUN bash download-extension.sh cldr
RUN bash download-extension.sh CleanChanges
RUN bash download-extension.sh CodeEditor
RUN bash download-extension.sh DeleteBatch
# Set version=master to get >= 3.0 to be able to use mw.ext.externaldata.getExternalData,
# see https://www.mediawiki.org/wiki/Extension:External_Data/Lua
# Should ideally be normalized in the future to use the recommanded version, instead of
# following master, to prevent breaking changes
RUN bash download-extension.sh ExternalData master
RUN bash download-extension.sh LocalisationUpdate
RUN bash download-extension.sh MobileFrontend
RUN bash download-extension.sh ParserFunctions
RUN bash download-extension.sh Scribunto
RUN bash download-extension.sh SendGrid
RUN bash download-extension.sh SyntaxHighlight_GeSHi
RUN bash download-extension.sh TemplateStyles
RUN bash download-extension.sh Translate
RUN bash download-extension.sh UniversalLanguageSelector

RUN for archive_file in *.tar.gz; do tar xzf "$archive_file"; done && rm ./*.tar.gz

RUN bash download-extension-OAuth2Client.sh

RUN mkdir -p /tmp/mediawiki && chown -R www-data:www-data /tmp/mediawiki

WORKDIR /var/www/html

RUN ln -s /var/www/html/ /var/www/html/w

RUN chmod a+x extensions/SyntaxHighlight_GeSHi/pygments/pygmentize

# Copy LocalSettings.php last, as it's much more likely to change
# than the rest, meaning that everytime it changes and a container is built,
# all the following steps will have to be re-executed without cache
COPY LocalSettings.php /LocalSettings.php

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
