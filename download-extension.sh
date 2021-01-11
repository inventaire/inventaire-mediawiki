#!/usr/bin/env bash
EXTENSION=$1
VERSION=${2:-"REL1_35"}

TAR_URL=$(curl -s "https://www.mediawiki.org/w/api.php?action=query&list=extdistbranches&edbexts=$EXTENSION&formatversion=2&format=json" | jq -r ".query.extdistbranches.extensions.$EXTENSION.$VERSION")
curl -s "$TAR_URL" -o "$EXTENSION".tar.gz
