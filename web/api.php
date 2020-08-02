<?php
$input_data = $_POST;
$myfile = fopen("/tmp/newfile.txt", "w") or die("Unable to open file!");
fwrite($myfile, $input_data);
fclose($myfile);
?>
