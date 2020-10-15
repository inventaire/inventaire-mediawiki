<?php
$filename = $argv[1];
$input_file = fopen($filename, "r");
$contents = fread($input_file, filesize($filename));
fclose($input_file);

$new_contents = "<translate>\n<languages />".$contents."\n</translate>\n";

$new_file = fopen("$filename.mediawiki", "w");
fwrite($new_file, $new_contents);
fclose($new_file);
?>
