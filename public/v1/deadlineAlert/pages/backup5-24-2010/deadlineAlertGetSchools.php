<?php
session_start();

include("../../commonPhp/mySqlConnect.php");

$keywords=$_POST["keywords"];

$sql="SELECT COLLEGE_ID, COLLEGE_NAME FROM TCOLLEGE WHERE LOWER(COLLEGE_NAME) LIKE LOWER('$keywords%') ORDER BY COLLEGE_NAME LIMIT 0,10";
$result=mysql_query($sql);
$responseString="";

while ($row=mysql_fetch_array($result))
{
	$responseString.=$row["COLLEGE_ID"] . "^" . $row["COLLEGE_NAME"] . "|";
}

echo substr($responseString,0,(strlen($responseString)-1));

include("../../commonPhp/mySqlClose.php");
?>