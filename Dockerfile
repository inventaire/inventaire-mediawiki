FROM mediawiki

# extension install inspired from https://github.com/wmde/wikibase-docker/blob/master/wikibase/1.35/bundle/Dockerfile

RUN apt update && \
    apt install --yes --no-install-recommends jq=1.* curl=7.* && \
    apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/extensions

COPY download-extension.sh .

# Add RUN command to each lines for development ease (instead of ending line with `;\`),
# as it does not recreate a container (and download all extensions again) when adding new extension

RUN bash download-extension.sh UniversalLanguageSelector
RUN bash download-extension.sh Babel
RUN bash download-extension.sh cldr
RUN bash download-extension.sh CleanChanges
RUN bash download-extension.sh LocalisationUpdate
RUN bash download-extension.sh Translate
RUN bash download-extension.sh UniversalLanguageSelector
RUN tar xzf Babel.tar.gz
RUN tar xzf cldr.tar.gz
RUN tar xzf CleanChanges.tar.gz
RUN tar xzf LocalisationUpdate.tar.gz
RUN tar xzf Translate.tar.gz
RUN tar xzf UniversalLanguageSelector.tar.gz

RUN rm ./*.tar.gz

WORKDIR /var/www/html

COPY ./inv.png ./resources/assets/inv.png
