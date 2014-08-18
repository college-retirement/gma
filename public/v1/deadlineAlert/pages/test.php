<?php
include("deadlineAlertHelper.php");
/*
$lastUpdated=strtotime("2010-05-10");
$todaysDate=date("Y-m-d");
$today=strtotime($todaysDate);
echo "**".(($today-$lastUpdated)/(60*60*24))."**";
*/
/*
$alertDesc="SAT Reasoning / ACT score report due by";
echo "*".substr($alertDesc,strlen($alertDesc)-3,strlen($alertDesc))."*<br>";
echo "*".substr($alertDesc,0,strlen($alertDesc)-3)."*";
*/
/*
$theDateStr="2010-05-17";
$theDateDate=strtotime($theDateStr);
$theDate=date("F j, Y",$theDateDate);
echo $theDate;
*/
/*
echo date("m");
echo "/";
echo date("d");
echo "/";
echo date("Y")+1;
*/
/*
$dueDate="Date unavailable, refer to school web site";
$webSite="http://www.psu.edu/";
$schoolName="Penn State";

$schoolNameHtml=((strpos(strtolower($dueDate), "unavailable")!==false) ? "<a href=\"" . $webSite . "\" target=\"_blank\">" . $schoolName . "</a>" : $schoolName);

echo $schoolNameHtml;
*/
phpinfo();
?>
