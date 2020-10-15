#!/bin/bash
set -eu
# Prerequisites:
#  - git clone git@github.com:inventaire/inventaire-wiki.git -b move-to-mediawiki imports/old-wiki
#  - add an extraline to every line to allow wikitext line break
#     cd imports/old-wiki
#     for F in *.md ; do sed -i 's/.*/&\n/' "$F" ;done
#  - convert to wikitext
#     for F in *.md ; do pandoc -f gfm $F -t mediawiki -o "$F".wikitext ;done

wikiPages=/imports/old-wiki/*.wikitext

for f in $wikiPages
do
  echo "Processing $f file..."
  php /imports/scripts/split_file_by_langs.php $f
done

echo "\n--- Created files by lang ---\n"

echo "\n--- Importing pages in english ---\n"

englishPages=/imports/old-wiki/*.en

for f in $englishPages
do
  filename_title="$(basename "$f" '.en')"
  echo "Processing $filename_title file..."
  if [ -f "/imports/old-wiki/$filename_title.en" ]
  then
  php /imports/scripts/format_canonical_pages.php "$f"
  php /var/www/html/maintenance/edit.php -s "import $filename_title page" -m "$filename_title" < "$f.mediawiki"
  fi
done

# echo "\n--- Importing pages in french ---\n"

touch /imports/pages_yet_to_import.md
touch /imports/pages_to_set_language.md

frenchPages=/imports/old-wiki/*.fr

for f in $frenchPages
do
  filename_title="$(basename "$f" '.fr')"
  echo "Processing $filename_title file..."
  if [ -f "/imports/old-wiki/$filename_title.en" ]
  then
    # canonical page is in english, leave $f for a manual import
    echo "nothing to upload to mediawiki"
    echo "- [ ] $f" >> /imports/pages_yet_to_import.md
  else
    php /imports/scripts/format_canonical_pages.php "$f"
    php /var/www/html/maintenance/edit.php -s "import $filename_title page" -m "$filename_title" < "$f.mediawiki"
    echo "- [ ] $f" >> /imports/pages_to_set_language.md
  fi
done

echo "\n--- Created files by lang ---\n"
