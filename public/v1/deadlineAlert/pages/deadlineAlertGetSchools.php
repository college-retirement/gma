<?php
session_start();

include("../../commonPhp/mySqlConnect.php");

$keywords=$_POST["keywords"];
$keywordsArray=explode(" ",$keywords);
$keywords1=$keywordsArray[0];
$keywords2=$keywordsArray[1];
$keywords3=$keywordsArray[2];
$keywords4=$keywordsArray[3];

$sqlArray=array(
"CREATE TEMPORARY TABLE TTEMP_SCHOOLS1 (COLLEGE_ID INT(11), COLLEGE_NAME VARCHAR(100))",
"CREATE TEMPORARY TABLE TTEMP_SCHOOLS2 (COLLEGE_ID INT(11), COLLEGE_NAME VARCHAR(100))",
"CREATE TEMPORARY TABLE TTEMP_SCHOOLS3 (COLLEGE_ID INT(11), COLLEGE_NAME VARCHAR(100))",
"INSERT INTO TTEMP_SCHOOLS1(COLLEGE_ID, COLLEGE_NAME) SELECT COLLEGE_ID, COLLEGE_NAME FROM TCOLLEGE WHERE LOWER(COLLEGE_NAME) LIKE LOWER('$keywords%') LIMIT 0,10",
"INSERT INTO TTEMP_SCHOOLS2(COLLEGE_ID, COLLEGE_NAME) SELECT COLLEGE_ID, COLLEGE_NAME FROM TCOLLEGE WHERE LOWER(COLLEGE_NAME) LIKE LOWER('%$keywords1%') AND LOWER(COLLEGE_NAME) LIKE LOWER('%$keywords2%') AND LOWER(COLLEGE_NAME) LIKE LOWER('%$keywords3%') AND LOWER(COLLEGE_NAME) LIKE LOWER('%$keywords4%')",
"INSERT INTO TTEMP_SCHOOLS3(COLLEGE_ID, COLLEGE_NAME) SELECT * FROM TTEMP_SCHOOLS1",
"INSERT INTO TTEMP_SCHOOLS3(COLLEGE_ID, COLLEGE_NAME) SELECT * FROM TTEMP_SCHOOLS2 WHERE COLLEGE_ID NOT IN (SELECT COLLEGE_ID FROM TTEMP_SCHOOLS1)",
"SELECT * FROM TTEMP_SCHOOLS3 LIMIT 0,10"
);

//$sql="SELECT COLLEGE_ID, COLLEGE_NAME FROM TCOLLEGE WHERE LOWER(COLLEGE_NAME) LIKE LOWER('$keywords%') ORDER BY COLLEGE_NAME LIMIT 0,10";
//$result=mysql_query($sql);

for ($i=0; $i<count($sqlArray); $i++)
{
	$result=mysql_query($sqlArray[$i]);
}

$responseString="";

while ($row=mysql_fetch_array($result))
{
	$responseString.=$row["COLLEGE_ID"] . "^" . $row["COLLEGE_NAME"] . "|";
}

echo $responseString=="" ? "0^No matches" : substr($responseString,0,(strlen($responseString)-1));

include("../../commonPhp/mySqlClose.php");
?>
