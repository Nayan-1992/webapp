<?php
$input_data = $_POST;
$myfile = fopen("/tmp/newfile.txt", "w") or die("Unable to open file!");
$post_string = implode('', $_POST);
fwrite($myfile, $post_string);
fclose($myfile);
?>
