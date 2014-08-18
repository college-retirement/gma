<?php
$dbhost="collretmysqldb.db.4264298.hostedresource.com";
$dbusername="collretmysqldb";
$dbpassword="crs667DB";
$dbname="collretmysqldb";

$conn=mysql_connect("$dbhost", "$dbusername", "$dbpassword") or die("cannot connect to MySQL DB: " . mysql_error()); 
mysql_select_db("$dbname") or die("cannot select MySQL DB: " . mysql_error());
?>