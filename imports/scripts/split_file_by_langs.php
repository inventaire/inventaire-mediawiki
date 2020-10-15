<?php
$filename = $argv[1];
$handle = fopen($filename, "r");
$contents = fread($handle, filesize($filename));
$parts = preg_split("/<!-- LANG:/", $contents);
fclose($handle);

$first_lang = mb_strtolower(preg_split("/, title=/", $parts[1])[0]);
$first_title = preg_split("/\"-->/", preg_split("/, title=\"/", $parts[1])[1])[0];
$first_text = preg_split("/\"-->/", $parts[1])[1];

if(sizeOf($parts) > 2) {
  $second_lang = mb_strtolower(preg_split("/, title=/", $parts[2])[0]);
  $second_title = preg_split("/\"-->/", preg_split("/, title=\"/", $parts[2])[1])[0];
  $second_text = preg_split("/\"-->/", $parts[2])[1];
};

if ($first_lang == "en" or !$second_title) {
  $main_title = $first_title;
} else {
  $main_title = $second_title;
};

$first_new_file = fopen("/imports/old-wiki/$main_title.$first_lang", "w");
fwrite($first_new_file, $first_text);
fclose($first_new_file);

if(sizeOf($parts) > 2) {
  $second_new_file = fopen("/imports/old-wiki/$main_title.$second_lang", "w");
  fwrite($second_new_file, $second_text);
  fclose($second_new_file);
};
?>
