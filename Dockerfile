FROM mediawiki

# extension install inspired from https://github.com/wmde/wikibase-docker/blob/master/wikibase/1.35/bundle/Dockerfile

RUN apt update && \
    apt install --yes --no-install-recommends jq=1.* curl=7.* && \
    apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/extensions

COPY LocalSettings.php /LocalSettings.php
COPY download-extension.sh .
COPY wait-for-it.sh /wait-for-it.sh
COPY entrypoint.sh /entrypoint.sh

# Add RUN command to each lines for development ease (instead of ending line with `;\`),
# as it does not recreate a container (and download all extensions again) when adding new extension

RUN bash download-extension.sh UniversalLanguageSelector
RUN bash download-extension.sh Babel
RUN bash download-extension.sh cldr
RUN bash download-extension.sh CleanChanges
RUN bash download-extension.sh LocalisationUpdate
RUN bash download-extension.sh Translate
RUN bash download-extension.sh UniversalLanguageSelector
RUN bash download-extension.sh DeleteBatch
RUN bash download-extension.sh SyntaxHighlight_GeSHi
RUN bash download-extension.sh MobileFrontend
RUN tar xzf Babel.tar.gz
RUN tar xzf cldr.tar.gz
RUN tar xzf CleanChanges.tar.gz
RUN tar xzf LocalisationUpdate.tar.gz
RUN tar xzf Translate.tar.gz
RUN tar xzf UniversalLanguageSelector.tar.gz
RUN tar xzf DeleteBatch.tar.gz
RUN tar xzf SyntaxHighlight_GeSHi.tar.gz
RUN tar xzf MobileFrontend.tar.gz

RUN rm ./*.tar.gz

WORKDIR /var/www/html

RUN chmod a+x extensions/SyntaxHighlight_GeSHi/pygments/pygmentize

COPY ./logo.png ./resources/assets/logo.png
COPY ./fav.ico ./resources/assets/fav.ico

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
