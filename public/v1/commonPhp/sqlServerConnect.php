<?php

$sqlServerDbServer="oldcrsdb.db.4264298.hostedresource.com";
$sqlServerUser="oldcrsdb";
$sqlServerPass="Shunp1ke";
$sqlServerDb="oldcrsdb"; 

$sqlServerConn=new COM("ADODB.Connection") or die("Cannot start ADO");

$sqlServerConnStr="PROVIDER=SQLOLEDB;SERVER=".$sqlServerDbServer.";UID=".$sqlServerUser.";PWD=".$sqlServerPass.";DATABASE=".$sqlServerDb; 
$sqlServerConn->open($sqlServerConnStr);

?>
