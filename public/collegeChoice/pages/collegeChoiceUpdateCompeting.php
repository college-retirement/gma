<?php
session_start();

$username=$_SESSION["username"];
$collegeId=addslashes($_POST["lstCollege"]);
//$name=addslashes($_POST["txtCollegeName"]);
$webSite=addslashes($_POST["txtWebSite"]);
$requestInfo=addslashes($_POST["txtRequestInfo"]);
$applyOnline=addslashes($_POST["txtApplyOnline"]);
$competingSchools=addslashes($_POST["hidCollegeNameSelected"]);

include("../../commonPhp/mySqlConnect.php");

//$sql="UPDATE TCOLLEGE SET COLLEGE_NAME='$name', DATE_UPDATED=NOW() WHERE COLLEGE_ID=$collegeId";
$sql="UPDATE TCOLLEGE SET WEB_SITE_URL='$webSite', REQUEST_INFO_URL='$requestInfo', APPLY_ONLINE_URL='$applyOnline', USER_UPDATED='$username', DATE_UPDATED=NOW() WHERE COLLEGE_ID=$collegeId";
$result=mysql_query($sql);

if ($result)
{
	$sql="DELETE FROM TCOLLEGE_COMPETE WHERE COLLEGE_ID=$collegeId";
	$result=mysql_query($sql);

	$competeSchools=explode(",", $competingSchools);

	for ($i=0; $i<count($competeSchools); $i++)
	{
		$sql="INSERT INTO TCOLLEGE_COMPETE (COLLEGE_ID, COMPETE_COLLEGE_ID, DATE_CREATED, USER_CREATED, DATE_UPDATED, USER_UPDATED) VALUES ($collegeId, $competeSchools[$i], NOW(), '$username', NOW(), '$username')";
		$result=mysql_query($sql);
	}
	include("../../commonPhp/mySqlClose.php");
	header("location:collegeChoiceCompetingMaintenance.php?id=" . $collegeId);
}
else
{
	//echo "error in updateCollege.php INSERT/UPDATE TCOLLEGE: "  . mysql_error();
	echo "error in collegeChoiceUpdateCompeting.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
	include("../../commonPhp/mySqlClose.php");
}
?>
