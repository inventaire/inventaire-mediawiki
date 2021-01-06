FROM mediawiki

# extension install inspired from https://github.com/wmde/wikibase-docker/blob/master/wikibase/1.35/bundle/Dockerfile

RUN apt update && \
    apt install --yes --no-install-recommends jq=1.* curl=7.* && \
    apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/extensions

COPY download-extension.sh .
COPY wait-for-it.sh /wait-for-it.sh
COPY entrypoint.sh /entrypoint.sh

# Add RUN command to each lines for development ease (instead of ending line with `;\`),
# as it does not recreate a container (and download all extensions again) when adding new extension

RUN bash download-extension.sh Babel
RUN bash download-extension.sh cldr
RUN bash download-extension.sh CleanChanges
RUN bash download-extension.sh LocalisationUpdate
RUN bash download-extension.sh Translate
RUN bash download-extension.sh UniversalLanguageSelector
RUN bash download-extension.sh DeleteBatch
RUN bash download-extension.sh SyntaxHighlight_GeSHi
RUN bash download-extension.sh MobileFrontend
RUN bash download-extension.sh Scribunto
RUN bash download-extension.sh TemplateStyles
RUN bash download-extension.sh CodeEditor
RUN curl -s https://gitlab.com/nonsensopedia/extensions/namespacepreload/-/archive/1c06653f/namespacepreload-1c06653f.tar.gz -o NamespacePreload.tar.gz
RUN tar xzf Babel.tar.gz
RUN tar xzf cldr.tar.gz
RUN tar xzf CleanChanges.tar.gz
RUN tar xzf LocalisationUpdate.tar.gz
RUN tar xzf Translate.tar.gz
RUN tar xzf UniversalLanguageSelector.tar.gz
RUN tar xzf DeleteBatch.tar.gz
RUN tar xzf SyntaxHighlight_GeSHi.tar.gz
RUN tar xzf MobileFrontend.tar.gz
RUN tar xzf Scribunto.tar.gz
RUN tar xzf TemplateStyles.tar.gz
RUN tar xzf CodeEditor.tar.gz
RUN tar xzf NamespacePreload.tar.gz && mv namespacepreload-1c06653f NamespacePreload

RUN rm ./*.tar.gz

WORKDIR /var/www/html

RUN ln -s /var/www/html/ /var/www/html/w

RUN chmod a+x extensions/SyntaxHighlight_GeSHi/pygments/pygmentize

COPY ./logo.png ./resources/assets/logo.png
COPY ./fav.ico ./resources/assets/fav.ico

# Copy LocalSettings.php last, as it's much more likely to change
# than the rest, meaning that everytime it changes and a container is built,
# all the following steps will have to be re-executed without cache
COPY LocalSettings.php /LocalSettings.php

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
